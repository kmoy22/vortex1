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

module VX_tcu_drl_shared_mul (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] fmt_s,
    input wire [15:0] a,
    input wire [15:0] b,
    input wire exp_low_larger,    //from exp_bias module
    input wire [6:0] raw_exp_diff,
    output logic [24:0] y
);
    //NOTE: exception handling neglected for now

    //fp16/bf16 pack 2 ops/reg --> need one instantiation per multiplier slice
    wire sign_f16 = a[15] ^ b[15];
    wire [10:0] a_f16 = fmt_s[0] ? {1'b1, a[9:0]} : {3'd0, 1'b1, a[6:0]};
    wire [10:0] b_f16 = fmt_s[0] ? {1'b1, b[9:0]} : {3'd0, 1'b1, b[6:0]};
    wire [21:0] y_f16;
    wire [21:0] y_f16_e;
    /*VX_wallace_mul #(
        .N (11)
    ) wtmul_f16 (
        .a (a_f16),
        .b (b_f16),
        .p (y_f16)
    );*/

    //fp8/bf8 pack 4 ops/ref --> need two instantiations per multiplier slice
    wire [1:0] sign_f8;
    wire [1:0][7:0] y_f8;
    for (genvar i = 0; i < 2; i++) begin  :  g_f8_mul
        assign sign_f8[i] = a[(i*8)+7] ^ b[(i*8)+7];
        wire [3:0] a_f8 = fmt_s[0] ? {1'b1, a[(i*8)+2 -: 3]} : {1'd0, 1'b1, a[(i*8)+1 -: 2]};
        wire [3:0] b_f8 = fmt_s[0] ? {1'b1, b[(i*8)+2 -: 3]} : {1'd0, 1'b1, b[(i*8)+1 -: 2]};
        VX_wallace_mul #(
            .N (4)
        ) wtmul_f8 (
            .a (a_f8),
            .b (b_f8),
            .p (y_f8[i])
        );
    end
    wire [6:0] shift_amount = exp_low_larger ?  -raw_exp_diff : raw_exp_diff;
    wire [7:0] y_f8_low  = fmt_s[0] ? y_f8[0] : {y_f8[0][5:0], 2'd0};
    wire [7:0] y_f8_high = fmt_s[0] ? y_f8[1] : {y_f8[1][5:0], 2'd0};
    wire [22:0] aligned_sig_low  = exp_low_larger ? {y_f8_low, 15'd0} : {y_f8_low, 15'd0} >> shift_amount;
    wire [22:0] aligned_sig_high = exp_low_larger ? {y_f8_high, 15'd0} >> shift_amount : {y_f8_high, 15'd0};
    wire [23:0] signed_sig_low  = sign_f8[0] ? -aligned_sig_low  : {1'b0, aligned_sig_low};
    wire [23:0] signed_sig_high = sign_f8[1] ? -aligned_sig_high : {1'b0, aligned_sig_high};
    wire [24:0] signed_sig_res;
    VX_ks_adder #(
        .N(24)
    ) sig_adder_f8 (
        .dataa (signed_sig_low),
        .datab (signed_sig_high),
        .sum   (signed_sig_res[23:0]),
        .cout  (signed_sig_res[24])
    );
    wire sign_f8_add = signed_sig_res[24];
    wire [23:0] y_f8_add = sign_f8_add ? -signed_sig_res[23:0] : signed_sig_res[23:0];

    //int8 pack 4 ops/reg --> need two instantiations per multiplier slice
    wire [1:0][15:0] y_i8;
    for (genvar i = 0; i < 2; i++) begin : g_i8_mul
        wire [7:0] a_i8 = a[8*i+7 -: 8];
        wire [7:0] b_i8 = b[8*i+7 -: 8];
        wire [7:0] abs_a_i8 = a_i8[7] ? -a_i8 : a_i8;
        wire [7:0] abs_b_i8 = b_i8[7] ? -b_i8 : b_i8;
        wire ab_sign_i8 = a_i8[7] ^ b_i8[7];
        wire [15:0] abs_y_i8;
        VX_wallace_mul #(
            .N (8)
        ) wtmul_i8 (
            .a (abs_a_i8),
            .b (abs_b_i8),
            .p (abs_y_i8)
        );
        assign y_i8[i] = ab_sign_i8 ? -abs_y_i8 : abs_y_i8;
    end
    wire [16:0] y_i8_add;
    VX_ks_adder #(
        .N(17)
    ) i8_adder (
        .dataa (17'($signed(y_i8[0]))),
        .datab (17'($signed(y_i8[1]))),
        .sum   (y_i8_add),
        `UNUSED_PIN (cout)
    );

    //uint4 pack 8 ops/reg --> need four instantiations per multiplier slice
    wire [3:0][7:0] y_u4;
    for (genvar i = 0; i < 4; i++) begin : g_u4_mul
        VX_wallace_mul #(
            .N (4)
        ) wtmul_u4 (
            .a (a[4*i+3 -: 4]),
            .b (b[4*i+3 -: 4]),
            .p (y_u4[i])
        );
    end
    wire [9:0] y_u4_add;
    VX_csa_tree #(
        .N (4),
        .W (8),
        .S (10)
    ) u4_adder (
        .operands (y_u4),
        .sum      (y_u4_add),
        `UNUSED_PIN (cout)
    );

    //Select sig out based on datatype
    logic [3:0] fmt_s_d;
    always_comb begin
        case (fmt_s_d)
            4'd1: y = {sign_f16, y_f16, 2'd0};          //fp16
            4'd2: y = {sign_f16, y_f16[15:0], 8'd0};    //bf16
            4'd3: y = {sign_f8_add, y_f8_add};          //fp8
            4'd4: y = {sign_f8_add, y_f8_add};          //bf8
            4'd9: y = 25'($signed(y_i8_add));           //int8
            4'd12: y = {15'd0, y_u4_add};               //uint4
            default: y = 25'hxxxxxxx;
        endcase
    end

    VX_pipe_register #(
        .DATAW (4),
        .DEPTH (4)
    ) fmt_s_pipe (
        .clk     (clk),
        .reset   (reset),
        .enable  (enable),
        .data_in (fmt_s),
        .data_out(fmt_s_d)
    );

    VX_pipe_register #(
        .DATAW (22),
        .DEPTH (1)
    ) y_f16_pipe (
        .clk     (clk),
        .reset   (reset),
        .enable  (enable),
        .data_in (y_f16_e),
        .data_out(y_f16)
    );

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

    assign y_f16_e = p[21:0];
    `UNUSED_VAR(p[47:22]);
    
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

    // Configure DSP Slice Inputs for A*B operation
    assign ain         = {19'b0, a_f16};
    assign bin         = {7'b0, b_f16};
    assign cin         = 48'b0;
    assign din         = 25'b0;
    assign acin        = 30'b0;
    assign bcin        = 18'b0;
    assign carrycascin = 1'b0;
    assign multsignin  = 1'b0;
    assign pcin        = 48'b0;
    assign carryinsel  = 3'b0;
    assign carryin     = 1'b0;

    // Configure the block to do an A*B operation
    assign alumode = 4'b0000;
    assign inmode  = 5'b10001;
    assign opmode  = 7'b0000101;

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
    assign cea1             = 1'b1;
    assign cea2             = 1'b1;
    assign cead             = 1'b1;
    assign cealumode        = 1'b1;
    assign ceb1             = 1'b1;
    assign ceb2             = 1'b1;
    assign cec              = 1'b1;
    assign cecarryin        = 1'b1;
    assign cectrl           = 1'b1;
    assign ced              = 1'b0;
    assign ceinmode         = 1'b1;
    assign cem              = 1'b1;
    assign cep              = 1'b1;
    assign rsta             = 1'b0;
    assign rstallcarryin    = 1'b0;
    assign rstalumode       = 1'b0;
    assign rstb             = 1'b0;
    assign rstc             = 1'b0;
    assign rstctrl          = 1'b0;
    assign rstd             = 1'b0;
    assign rstinmode        = 1'b0;
    assign rstm             = 1'b0;
    assign rstp             = 1'b0;

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
    fp16_mul (
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
