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

module VX_tcu_drl_exp_bias (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [2:0] fmt_s,
    input wire [15:0] a,
    input wire [15:0] b,
    output logic [7:0] raw_exp_y,
    output logic exp_low_larger,
    output logic [6:0] raw_exp_diff
);
    //NOTE: exception handling neglected for now
    `UNUSED_VAR({a, b, enable});
    `UNUSED_VAR(reset);
    `UNUSED_VAR(clk);

    //logic [7:0] raw_exp_y_e;
    //logic exp_low_larger_e;
    //logic [6:0] raw_exp_diff_e;

    //FP16 exponent addition and bias
    wire [7:0] raw_exp_fp16;
    wire [7:0] fp16_32_conv_bias = 8'd98;    //127-30 + 1
    /*
    VX_csa_tree #(
        .N(3),
        .W(8),
        .S(8)
    ) biasexp_fp16(
        .operands({{3'd0, a[14:10]}, {3'd0, b[14:10]}, fp16_32_conv_bias}),
        .sum     (raw_exp_fp16),
        `UNUSED_PIN (cout)
    );*/
    
    //BF16 exponent addition and bias
    wire [7:0] raw_exp_bf16;
    wire [9:0] neg_bias = 10'b1110000010; //-127+1
    wire [9:0] raw_exp_bf16_signed;
    `UNUSED_VAR(raw_exp_bf16_signed);
    VX_csa_tree #(
        .N(3),
        .W(10),
        .S(10)
    ) biasexp_bf16(
        .operands({{2'd0, a[14:7]}, {2'd0, b[14:7]}, neg_bias}),
        .sum     (raw_exp_bf16_signed),
        `UNUSED_PIN (cout)
    );
    assign raw_exp_bf16 = raw_exp_bf16_signed[9] ? -raw_exp_bf16_signed[7:0] : raw_exp_bf16_signed[7:0];

    //FP8 (E4M3) exponent addition and bias
    wire [7:0] raw_exp_fp8;
    wire [1:0][4:0] raw_exp_fp8_sub;
    for (genvar i = 0; i < 2; i++) begin  :  g_fp8_sub
        VX_ks_adder #(
            .N(4)
        ) raw_exp_fp8_sub_add (
            .dataa (a[(i*8)+6 -: 4]),
            .datab (b[(i*8)+6 -: 4]),
            .sum   (raw_exp_fp8_sub[i][3:0]),
            .cout  (raw_exp_fp8_sub[i][4])
        );
    end
    wire [5:0] raw_exp_fp8_diff = {1'b0, raw_exp_fp8_sub[1]} - {1'b0, raw_exp_fp8_sub[0]};
    wire fp8_exp_low_larger = raw_exp_fp8_diff[5];
    wire [4:0] raw_exp_fp8_unbiased = fp8_exp_low_larger ? raw_exp_fp8_sub[0] : raw_exp_fp8_sub[1];
    wire [7:0] fp8_conv_bias_fp32 = 8'd115;    //127-14+2
    VX_ks_adder #(
        .N(8)
    ) biasexp_fp8 (
        .dataa ({3'd0, raw_exp_fp8_unbiased}),
        .datab (fp8_conv_bias_fp32),
        .sum   (raw_exp_fp8),
        `UNUSED_PIN (cout)
    );

    //BF8 (E5M2) exponent addition and bias
    wire [7:0] raw_exp_bf8;
    wire [1:0][5:0] raw_exp_bf8_sub;
    for (genvar j = 0; j < 2; j++) begin  :  g_bf8_sub
        VX_ks_adder #(
            .N(5)
        ) raw_exp_bf8_sub_add (
            .dataa (a[(j*8)+6 -: 5]),
            .datab (b[(j*8)+6 -: 5]),
            .sum   (raw_exp_bf8_sub[j][4:0]),
            .cout  (raw_exp_bf8_sub[j][5])
        );
    end
    wire [6:0] raw_exp_bf8_diff = {1'b0, raw_exp_bf8_sub[1]} - {1'b0, raw_exp_bf8_sub[0]};
    wire bf8_exp_low_larger = raw_exp_bf8_diff[6];
    wire [5:0] raw_exp_bf8_unbiased = bf8_exp_low_larger ? raw_exp_bf8_sub[0] : raw_exp_bf8_sub[1];
    wire [7:0] bf8_conv_bias_fp32 = 8'd99;    //127-30+2
    VX_ks_adder #(
        .N(8)
    ) biasexp_bf8 (
        .dataa ({2'd0, raw_exp_bf8_unbiased}),
        .datab (bf8_conv_bias_fp32),
        .sum   (raw_exp_bf8),
        `UNUSED_PIN (cout)
    );

    //Select exp out based on datatype
    always_comb begin
        case(fmt_s[2:0])
            3'd1: begin
                raw_exp_y      = raw_exp_fp16;
                exp_low_larger = 1'bx;
                raw_exp_diff   = 7'dx;                 
            end
            3'd2: begin
                raw_exp_y      = raw_exp_bf16;
                exp_low_larger = 1'bx;
                raw_exp_diff   = 7'dx;                    
            end
            3'd3: begin
                raw_exp_y      = raw_exp_fp8;
                exp_low_larger = fp8_exp_low_larger;
                raw_exp_diff   = {raw_exp_fp8_diff[5], raw_exp_fp8_diff};                    
            end
            3'd4: begin
                raw_exp_y      = raw_exp_bf8;
                exp_low_larger = bf8_exp_low_larger;
                raw_exp_diff   = raw_exp_bf8_diff;                    
            end
            default: begin
                raw_exp_y      = 8'dx;
                exp_low_larger = 1'bx;
                raw_exp_diff   = 7'dx;
            end
        endcase
    end
/*
    VX_pipe_register #(
        .DATAW (8+7+1),
        .DEPTH (2)
    ) bias_pipe (
        .clk     (clk),
        .reset   (reset),
        .enable  (enable),
        .data_in ({raw_exp_y_e, exp_low_larger_e, raw_exp_diff_e}),
        .data_out({raw_exp_y, exp_low_larger, raw_exp_diff})
    );*/


    // DSP Block Signals - Outputs
    logic [29:0] acout;
    logic [17:0] bcout;
    logic carrycascout;
    logic multsignout;
    logic [47:0] pcout;
    logic overflow;
    logic patternbdetect;
    logic patterndetect;
    logic underflow;
    logic [3:0] carryout;
    logic [47:0] p;

    // Only care about the P output
    `UNUSED_VAR(acout);
    `UNUSED_VAR(bcout);
    `UNUSED_VAR(carrycascout);
    `UNUSED_VAR(multsignout);
    `UNUSED_VAR(pcout);
    `UNUSED_VAR(overflow);
    `UNUSED_VAR(patternbdetect);
    `UNUSED_VAR(patterndetect);
    `UNUSED_VAR(underflow);    
    `UNUSED_VAR(carryout);

    assign raw_exp_fp16 = p[7:0];
    `UNUSED_VAR(p[47:8]);
    
    // DSP Block Signals - Inputs
    wire [29:0] acin;
    wire [17:0] bcin;
    wire carrycascin;
    wire multsignin;
    wire [47:0] pcin;
    wire [3:0] alumode;
    wire [2:0] carryinsel;
    wire [4:0] inmode;
    wire [6:0] opmode;
    wire [29:0] ain;
    wire [17:0] bin;
    wire [47:0] cin;
    wire carryin;
    wire [24:0] din;

    // Configure DSP Slice Inputs for (A + D)*B + C operation
    assign ain         = {22'b0, 3'd0, a[14:10]};
    assign bin         = 18'b1;
    assign cin         = {40'b0, fp16_32_conv_bias};
    assign din         = {17'b0, 3'd0, b[14:10]};
    assign acin        = 30'b0;
    assign bcin        = 18'b0;
    assign carrycascin = 1'b0;
    assign multsignin  = 1'b0;
    assign pcin        = 48'b0;
    assign carryinsel  = 3'b0;
    assign carryin     = 1'b0;

    // Configure the block to do an A + D + C operation, where B = 1
    assign alumode = 4'b0000;
    assign inmode  = 5'b10101;
    assign opmode  = 7'b0110101;

    // DSP Slice Reset/Clock Enable Inputs
    wire cea1;
    wire cea2;
    wire cead;
    wire cealumode;
    wire ceb1;
    wire ceb2;
    wire cec;
    wire cecarryin;
    wire cectrl;
    wire ced;
    wire ceinmode;
    wire cem;
    wire cep;
    wire rsta;
    wire rstallcarryin;
    wire rstalumode;
    wire rstb;
    wire rstc;
    wire rstctrl;
    wire rstd;
    wire rstinmode;
    wire rstm;
    wire rstp;

    // Configure reset/clock enables
    assign cea1              = 1'b1;
    assign cea2              = 1'b1;
    assign cead              = 1'b1;
    assign cealumode         = 1'b1;
    assign ceb1              = 1'b1;
    assign ceb2              = 1'b1;
    assign cec               = 1'b1;
    assign cecarryin         = 1'b1;
    assign cectrl            = 1'b1;
    assign ced               = 1'b0;
    assign ceinmode          = 1'b1;
    assign cem               = 1'b1;
    assign cep               = 1'b1;
    assign rsta              = 1'b0;
    assign rstallcarryin     = 1'b0;
    assign rstalumode        = 1'b0;
    assign rstb              = 1'b0;
    assign rstc              = 1'b0;
    assign rstctrl           = 1'b0;
    assign rstd              = 1'b0;
    assign rstinmode         = 1'b0;
    assign rstm              = 1'b0;
    assign rstp              = 1'b0;
    
    DSP48E1 #(
        // Feature Control Attributes: Data Path Selection
        .A_INPUT("DIRECT"),               // Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
        .B_INPUT("DIRECT"),               // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
        .USE_DPORT("FALSE"),              // Select D port usage (TRUE or FALSE)
        .USE_MULT("MULTIPLY"),            // Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
        .USE_SIMD("ONE48"),               // SIMD selection ("ONE48", "TWO24", "FOUR12")
        // Pattern Detector Attributes: Pattern Detection Configuration
        .AUTORESET_PATDET("NO_RESET"),    // "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH"
        .MASK(48'h3fffffffffff),          // 48-bit mask value for pattern detect (1=ignore)
        .PATTERN(48'h000000000000),       // 48-bit pattern match for pattern detect
        .SEL_MASK("MASK"),                // "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2"
        .SEL_PATTERN("PATTERN"),          // Select pattern value ("PATTERN" or "C")
        .USE_PATTERN_DETECT("NO_PATDET"), // Enable pattern detect ("PATDET" or "NO_PATDET")
        // Register Control Attributes: Pipeline Register Configuration
        .ACASCREG(1),                     // Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
        .ADREG(1),                        // Number of pipeline stages for pre-adder (0 or 1)
        .ALUMODEREG(1),                   // Number of pipeline stages for ALUMODE (0 or 1)
        .AREG(1),                         // Number of pipeline stages for A (0, 1 or 2)
        .BCASCREG(1),                     // Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
        .BREG(1),                         // Number of pipeline stages for B (0, 1 or 2)
        .CARRYINREG(1),                   // Number of pipeline stages for CARRYIN (0 or 1)
        .CARRYINSELREG(1),                // Number of pipeline stages for CARRYINSEL (0 or 1)
        .CREG(1),                         // Number of pipeline stages for C (0 or 1)
        .DREG(1),                         // Number of pipeline stages for D (0 or 1)
        .INMODEREG(1),                    // Number of pipeline stages for INMODE (0 or 1)
        .MREG(1),                         // Number of multiplier pipeline stages (0 or 1)
        .OPMODEREG(1),                    // Number of pipeline stages for OPMODE (0 or 1)
        .PREG(1)                          // Number of pipeline stages for P (0 or 1)
    )
    bias_adder (
        // Cascade: 30-bit (each) output: Cascade Ports
        .ACOUT(acout),                   // 30-bit output: A port cascade output
        .BCOUT(bcout),                   // 18-bit output: B port cascade output
        .CARRYCASCOUT(carrycascout),     // 1-bit output: Cascade carry output
        .MULTSIGNOUT(multsignout),       // 1-bit output: Multiplier sign cascade output
        .PCOUT(pcout),                   // 48-bit output: Cascade output
        // Control: 1-bit (each) output: Control Inputs/Status Bits
        .OVERFLOW(overflow),             // 1-bit output: Overflow in add/acc output
        .PATTERNBDETECT(patternbdetect), // 1-bit output: Pattern bar detect output
        .PATTERNDETECT(patterndetect),   // 1-bit output: Pattern detect output
        .UNDERFLOW(underflow),           // 1-bit output: Underflow in add/acc output
        // Data: 4-bit (each) output: Data Ports
        .CARRYOUT(carryout),             // 4-bit output: Carry output
        .P(p),                           // 48-bit output: Primary data output
        // Cascade: 30-bit (each) input: Cascade Ports
        .ACIN(acin),                     // 30-bit input: A cascade data input
        .BCIN(bcin),                     // 18-bit input: B cascade input
        .CARRYCASCIN(carrycascin),       // 1-bit input: Cascade carry input
        .MULTSIGNIN(multsignin),         // 1-bit input: Multiplier sign input
        .PCIN(pcin),                     // 48-bit input: P cascade input
        // Control: 4-bit (each) input: Control Inputs/Status Bits
        .ALUMODE(alumode),               // 4-bit input: ALU control input
        .CARRYINSEL(carryinsel),         // 3-bit input: Carry select input
        .CLK(clk),                       // 1-bit input: Clock input
        .INMODE(inmode),                 // 5-bit input: INMODE control input
        .OPMODE(opmode),                 // 7-bit input: Operation mode input
        // Data: 30-bit (each) input: Data Ports
        .A(ain),                           // 30-bit input: A data input
        .B(bin),                           // 18-bit input: B data input
        .C(cin),                           // 48-bit input: C data input
        .CARRYIN(carryin),               // 1-bit input: Carry input signal
        .D(din),                           // 25-bit input: D data input
        // Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
        .CEA1(cea1),                     // 1-bit input: Clock enable input for 1st stage AREG
        .CEA2(cea2),                     // 1-bit input: Clock enable input for 2nd stage AREG
        .CEAD(cead),                     // 1-bit input: Clock enable input for ADREG
        .CEALUMODE(cealumode),           // 1-bit input: Clock enable input for ALUMODE
        .CEB1(ceb1),                     // 1-bit input: Clock enable input for 1st stage BREG
        .CEB2(ceb2),                     // 1-bit input: Clock enable input for 2nd stage BREG
        .CEC(cec),                       // 1-bit input: Clock enable input for CREG
        .CECARRYIN(cecarryin),           // 1-bit input: Clock enable input for CARRYINREG
        .CECTRL(cectrl),                 // 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
        .CED(ced),                       // 1-bit input: Clock enable input for DREG
        .CEINMODE(ceinmode),             // 1-bit input: Clock enable input for INMODEREG
        .CEM(cem),                       // 1-bit input: Clock enable input for MREG
        .CEP(cep),                       // 1-bit input: Clock enable input for PREG
        .RSTA(rsta),                     // 1-bit input: Reset input for AREG
        .RSTALLCARRYIN(rstallcarryin),   // 1-bit input: Reset input for CARRYINREG
        .RSTALUMODE(rstalumode),         // 1-bit input: Reset input for ALUMODEREG
        .RSTB(rstb),                     // 1-bit input: Reset input for BREG
        .RSTC(rstc),                     // 1-bit input: Reset input for CREG
        .RSTCTRL(rstctrl),               // 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
        .RSTD(rstd),                     // 1-bit input: Reset input for DREG and ADREG
        .RSTINMODE(rstinmode),           // 1-bit input: Reset input for INMODEREG
        .RSTM(rstm),                     // 1-bit input: Reset input for MREG
        .RSTP(rstp)                      // 1-bit input: Reset input for PREG
    );

endmodule
