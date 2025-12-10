// Copyright © 2019-2023
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

`include "VX_define.vh"

module VX_tcu_fedp_drl #(
    parameter int N = 4,
    parameter int LATENCY = 0
) (
    input wire clk,
    input wire reset,
    input wire enable,

    input wire [N-1:0][31:0] a_row,
    input wire [N-1:0][31:0] b_col,
    input wire [31:0] c_val,
    output wire [31:0] d_val
);

    //N_DRL = N multiplication + 1 addition
    localparam int N_DRL = N + 1;

    //latency of each stagw
    //kind of conservative
    localparam int FMUL_LATENCY = 3; //DSP48E1 pipeline depth should be 2 or 3
    localparam int ALN_LATENCY = 1; //alignment latency should be 1
    localparam int ACC_LATENCY = 1; //accumulator latency should be 1
    localparam int FRND_LATENCY = 2; //rounding latency should be 2

    localparam int TOTAL_LATENCY = FMUL_LATENCY + ALN_LATENCY + ACC_LATENCY + FRND_LATENCY;

    //if latency is 0, no pipeline; otherwise, pipeline is needed
    `STATIC_ASSERT (
        LATENCY == 0 || LATENCY == TOTAL_LATENCY,
        ("Bad FEDP DRL FP32 latency! expected=%0d, actual=%0d",
        TOTAL_LATENCY, LATENCY)
    );

    //stage 0: mul_exp for fp32
    wire [7:0] raw_max_exp;
    wire [N_DRL-1:0][7:0] shift_amounts;
    wire [N_DRL-1:0][24:0] raw_sigs;

    VX_tcu_drl_mul_exp #(
        .N(N_DRL)
    ) mul_exp_fp32 (
        .enable     (enable),
        .reset      (reset),
        .clk        (clk),
        .a_rows     (a_row),
        .b_cols     (b_col),
        .c_val      (c_val),
        .raw_sigs   (raw_sigs),
        .raw_exps   (raw_exps),
        .raw_max_exp(raw_max_exp),
        .shift_amounts(shift_amounts)
    );

    //stage 0 -> stage 1: pipeline reg
    wire [7:0] pipe_raw_max_exp;
    wire [N_DRL-1:0][7:0] pipe_shift_amounts;
    wire [N_DRL-1:0][24:0] pipe_raw_sigs;

    generate
        if (LATENCY != 0) begin: g_pipe_fmul
            VX_pipe_register #(
                .DATAW (8+((N_DRL)*8)+((N_DRL)*25)),
                .DEPTH (FMUL_LATENCY)
            ) pipe_fmul (
                .clk     (clk),
                .reset   (reset),
                .enable  (enable),
                .data_in ({raw_max_exp, shift_amounts, raw_sigs}),
                .data_out({pipe_raw_max_exp, pipe_shift_amounts, pipe_raw_sigs})
            );
        end else begin: g_no_pipe_fmul
            assign pipe_raw_max_exp = raw_max_exp;
            assign pipe_shift_amounts = shift_amounts;
            assign pipe_raw_sigs = raw_sigs;
        end
    endgenerate


    //stage 1: alignment
    wire [7:0] aln_max_exp = pipe_raw_max_exp;
    wire [N_DRL-1:0][24:0] aln_sigs;

    VX_tcu_drl_align #(
        .N(N_DRL)
    ) sigs_align_fp32 (
        .shift_amounts(pipe_shift_amounts),
        .sigs_in(pipe_raw_sigs),
        .fmt_sel(1'b0), //fmt_sel is 0 for fp32
        .sigs_out(aln_sigs)
    );

    //stage 1 -> stage 2: pipeline reg
    wire [7:0] pipe_aln_max_exp;
    wire [N_DRL-1:0][24:0] pipe_aln_sigs;

    generate
        if (LATENCY != 0) begin: g_pipe_aln
            VX_pipe_register #(
                .DATAW (8+((N_DRL)*25)),
                .DEPTH (ALN_LATENCY)
            ) pipe_aln (
                .clk     (clk),
                .reset   (reset),
                .enable  (enable),
                .data_in ({pipe_aln_max_exp, pipe_aln_sigs}),
                .data_out({pipe_aln_max_exp, pipe_aln_sigs})
            );
        end else begin: g_no_pipe_aln
            assign pipe_aln_max_exp = aln_max_exp;
            assign pipe_aln_sigs = aln_sigs;
        end
    endgenerate

    // stage 2: accumulation
    wire [25+$clog2(N_DRL):0] acc_sig;

    VX_tcu_drl_acc #(
        .N(N_DRL)
    ) acc_fp32 (
        .clk        (clk),
        .reset      (reset),
        .enable     (enable),
        .sigsIn(pipe_aln_sigs),
        .fmt_sel(1'b0), //fmt_sel is 0 for fp32
        .sigOut(acc_sig),
        .signOuts(acc_signs) //need to check the exact format
    );

    //stage 2 -> stage 3: pipeline reg
    wire [25+$clog2(N_DRL):0] pipe_acc_sig;
    wire [7:0] pipe_acc_max_exp;

    generate
        if (LATENCY != 0) begin: g_pipe_acc
            VX_pipe_register #(
                .DATAW (25+$clog2(N_DRL)+1),
                .DEPTH (ACC_LATENCY)
            ) pipe_acc (
                .clk     (clk),
                .reset   (reset),
                .enable  (enable),
                .data_in ({pipe_acc_max_exp, pipe_acc_sig}),
                .data_out({pipe_acc_max_exp, pipe_acc_sig})
            );
        end else begin: g_no_pipe_acc
            assign pipe_acc_max_exp = acc_max_exp;
            assign pipe_acc_sig = acc_sig;
        end
    endgenerate

    //stage 3: rounding
    wire [31:0] rnd_result;

    VX_tcu_drl_norm_round #(
        .N(N_DRL)
    ) norm_round_fp32 (
        .max_exp(pipe_acc_max_exp),
        .acc_sig(pipe_acc_sig),
        .hi_c(pipe_acc_hi_c),
        .sigSigns(acc_signs),
        .fmt_sel(1'b0), //fmt_sel is 0 for fp32
        .result(rnd_result)
    );

    //stage 3 -> stage 4: pipeline reg

    generate
        if (LATENCY != 0) begin: g_pipe_out
            VX_pipe_register #(
                .DATAW (32),
                .DEPTH (FRND_LATENCY)
            ) pipe_out (
                .clk     (clk),
                .reset   (reset),
                .enable  (enable),
                .data_in (rnd_result),
                .data_out(d_val)
            );
        end else begin: g_no_pipe_out
            assign d_val = rnd_result;
        end
    endgenerate

endmodule
