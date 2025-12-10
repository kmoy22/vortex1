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

//This is a model that combined VX_tcu_drl_shared_mul, VX_tcu_drl_exp_bias and VX_tcu_drl_max_exp
//for fp32 multiplication in 2 DSP slices

module VX_tcu_drl_mul_exp (
    parameter N = 5  //includes c_val count
) (
    input wire enable,
    input wire reset,
    input wire clk,

    input wire [N-2:0][31:0] a_rows,
    input wire [N-2:0][31:0] b_cols,
    input wire [31:0] c_val,

    output wire [N-1:0][24:0] raw_sigs,
    output wire [N-1:0][7:0] raw_exps,
    output wire [7:0] raw_max_exp,
    output wire [N-1:0][7:0] shift_amounts
);

// for every i in N-1
for (genvar i = 0; i < N-1; ++i) begin : mul_exp_fp32
    //shared multimul on mantissa
    VX_tcu_drl_shared_mul u_shared_mul_fp32 (
        .clk        (clk),
        .reset      (reset),
        .enable     (enable),
        .fmt_s      (fmt_s),
        .a          (a_rows[i]),
        .b          (b_cols[i]),
        .y          (raw_sigs[i])
    );

    //exponent add and bias
    VX_tcu_drl_exp_bias u_exp_bias_fp32 (
        .enable     (enable),
        .fmt_s      (fmt_s),
        .a          (a_rows[i]),
        .b          (b_cols[i]),
        .raw_exp_y  (raw_exps[i]),
        .exp_low_larger (exp_low_larger),
        .raw_exp_diff   (raw_exp_diff)
    );
end

//c_val integration
assign raw_exps[N-1] = c_val[30:23];
assign raw_siga[N-1] = {c_val[31], 1'b1, c_val[22:0]};

//Raw maximum exponent finder (in parallel to mul) and shift amounts
VX_tcu_drl_max_exp #(
    .N(N)
) u_max_exp (
    .exponents     (raw_exps),
    .max_exp       (raw_max_exp),
    .shift_amounts (shift_amounts)
);
endmodule
