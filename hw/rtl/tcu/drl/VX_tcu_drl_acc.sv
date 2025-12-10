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

module VX_tcu_drl_acc #(
    parameter N = 5,         //include c_val count
    parameter W = 25+$clog2(N)+1
) (
    input  wire clk,
    input  wire reset,
    input  wire enable,
    input  wire [N-1:0][24:0] sigsIn,
    input  wire fmt_sel,
    output logic [W-1:0] sigOut,
    output logic [N-2:0] signOuts
);
    // Sign-extend fp significands to W bits
    wire [N-1:0][W-1:0] sigsIn_ext;
    for (genvar i = 0; i < N; i++) begin : g_ext_sign
        assign sigsIn_ext[i] = fmt_sel ? {{(W-25){1'b0}}, sigsIn[i]} : {{(W-25){sigsIn[i][24]}}, sigsIn[i]};
    end

    /*
    //Carry-Save-Adder based significand accumulation
    VX_csa_half_en #(
        .N (N),
        .W (W),
        .S (W-1)
    ) sig_csa (
        .operands (sigsIn_ext),
        .half_en (1'b1),    // TODO: feed sparsity control signal when resolved
        .sum  (sigOut[W-2:0]),
        .cout (sigOut[W-1])
    );
    */

    // DSP Slice Outputs
    logic [N-1:0][29:0] acout;
    logic [N-1:0][17:0] bcout;
    logic [N-1:0] carrycascout;
    logic [N-1:0] multsignout;
    logic [N-1:0][47:0] pcout;
    logic [N-1:0] overflow;
    logic [N-1:0] patternbdetect;
    logic [N-1:0] patterndetect;
    logic [N-1:0] underflow;
    logic [N-1:0][3:0] carryout;
    logic [N-1:0][47:0] p;

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

    // DSP Slice Inputs
    wire [N-1:0][29:0] acin;
    wire [N-1:0][17:0] bcin;
    wire [N-1:0] carrycascin;
    wire [N-1:0] multsignin;
    wire [N-1:0][47:0] pcin;
    wire [N-1:0][3:0] alumode;
    wire [N-1:0][2:0] carryinsel;
    wire [N-1:0] clk;
    wire [N-1:0][4:0] inmode;
    wire [N-1:0][6:0] opmode;
    wire [N-1:0][29:0] a;
    wire [N-1:0][17:0] b;
    wire [N-1:0][47:0] c;
    wire [N-1:0] carryin;
    wire [N-1:0][24:0] d;

    // Configure DSP Slice Inputs
    for (genvar i = 0; i < N; i++) begin
        assign d[i]             = 25'b0; // Note: D the pre-adder input, which has a limit of only 24 bits
        assign acin[i]          = 30'b0;
        assign bcin[i]          = 18'b0;
        assign carrycascin[i]   = 1'b0;
        assign multsignin[i]    = 1'b0;
        assign pcin[i]          = 48'b0;
        assign carryinsel[i]    = 3'b0;

        // Configure the block to do an A:B + C operation, where B = 1
        assign alumode[i]       = 4'b0;
        assign inmode[i]        = 5'b0;
        assign opmode[i]        = 7'b0001111;
        
        assign carryin[i]       = 1'b0;
    end

    // Adder Tree Pipeline
    wire [24:0] sigsIn_4_d2;
    wire [25:0] p_1_d2;

    assign b[0] = sigsIn[0][17:0];
    assign a[0] = {23'b0, sigsIn[0][24:18]};
    assign c[0] = {23'b0, sigsIn[1][24:0]};

    assign b[1] = sigsIn[2][17:0];
    assign a[1] = {23'b0, sigsIn[2][24:18]};
    assign c[1] = {23'b0, sigsIn[3][24:0]};  

    VX_pipe_register #(
        .DATAW (25),
        .DEPTH (2)
    ) input_4_pipe (
        .clk     (clk),
        .reset   (reset),
        .enable  (enable),
        .data_in (sigsIn[4]),
        .data_out(sigsIn_4_d2)
    );

    assign b[2] = sigsIn_4_d2[17:0];
    assign a[2] = {23'b0, sigsIn_4_d2[24:18]};
    assign c[2] = p[0];

    `UNUSED_VAR(p[1][47:26]); // Only need one extra bit as a carry

    VX_pipe_register #(
        .DATAW (26),
        .DEPTH (2)
    ) input_4_pipe (
        .clk     (clk),
        .reset   (reset),
        .enable  (enable),
        .data_in (p[1][25:0]),
        .data_out(p_1_d2)
    );

    assign b[3] = p_1_d2[17:0];
    assign a[3] = {22'b0, p_1_d2[26:18]}; 
    assign c[3] = p[2];

    assign sigOut = p[3][W-1:0];
    `UNUSED_VAR(p[3][47:W]); // Only need one extra bit as a carry

    // DSP Slice Reset/Clock Enable Inputs
    wire [N-1:0] cea1;
    wire [N-1:0] cea2;
    wire [N-1:0] cead;
    wire [N-1:0] cealumode;
    wire [N-1:0] ceb1;
    wire [N-1:0] ceb2;
    wire [N-1:0] cec;
    wire [N-1:0] cecarryin;
    wire [N-1:0] cectrl;
    wire [N-1:0] ced;
    wire [N-1:0] ceinmode;
    wire [N-1:0] cem;
    wire [N-1:0] cep;
    wire [N-1:0] rsta;
    wire [N-1:0] rstallcarryin;
    wire [N-1:0] rstalumode;
    wire [N-1:0] rstb;
    wire [N-1:0] rstc;
    wire [N-1:0] rstctrl;
    wire [N-1:0] rstd;
    wire [N-1:0] rstinmode;
    wire [N-1:0] rstm;
    wire [N-1:0] rstp;

    // Configure reset/clock enables
    for (genvar i = 0; i < N; i++) begin : g_rsts_ce
        assign clk[i]               = clk;
        assign cea1[i]              = 1'b1;
        assign cea2[i]              = 1'b1;
        assign cead[i]              = 1'b1;
        assign cealumode[i]         = 1'b1;
        assign ceb1[i]              = 1'b1;
        assign ceb2[i]              = 1'b1;
        assign cec[i]               = 1'b1;
        assign cecarryin[i]         = 1'b1;
        assign cectrl[i]            = 1'b1;
        assign ced[i]               = 1'b0;
        assign ceinmode[i]          = 1'b1;
        assign cem[i]               = 1'b1;
        assign cep[i]               = 1'b1;
        assign rsta[i]              = 1'b0;
        assign rstallcarryin[i]     = 1'b0;
        assign rstalumode[i]        = 1'b0;
        assign rstb[i]              = 1'b0;
        assign rstc[i]              = 1'b0;
        assign rstctrl[i]           = 1'b0;
        assign rstd[i]              = 1'b0;
        assign rstinmode[i]         = 1'b0;
        assign rstm[i]              = 1'b0;
        assign rstp[i]              = 1'b0;
    end

    genvar i;
    generate
        for (genvar i = 0; i < N; i++) begin : inst_slices
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
            dsp_adder (
                // Cascade: 30-bit (each) output: Cascade Ports
                .ACOUT(acout[i]),                   // 30-bit output: A port cascade output
                .BCOUT(bcout[i]),                   // 18-bit output: B port cascade output
                .CARRYCASCOUT(carrycascout[i]),     // 1-bit output: Cascade carry output
                .MULTSIGNOUT(multsignout[i]),       // 1-bit output: Multiplier sign cascade output
                .PCOUT(pcout[i]),                   // 48-bit output: Cascade output
                // Control: 1-bit (each) output: Control Inputs/Status Bits
                .OVERFLOW(overflow[i]),             // 1-bit output: Overflow in add/acc output
                .PATTERNBDETECT(patternbdetect[i]), // 1-bit output: Pattern bar detect output
                .PATTERNDETECT(patterndetect[i]),   // 1-bit output: Pattern detect output
                .UNDERFLOW(underflow[i]),           // 1-bit output: Underflow in add/acc output
                // Data: 4-bit (each) output: Data Ports
                .CARRYOUT(carryout[i]),             // 4-bit output: Carry output
                .P(p[i]),                           // 48-bit output: Primary data output
                // Cascade: 30-bit (each) input: Cascade Ports
                .ACIN(acin[i]),                     // 30-bit input: A cascade data input
                .BCIN(bcin[i]),                     // 18-bit input: B cascade input
                .CARRYCASCIN(carrycascin[i]),       // 1-bit input: Cascade carry input
                .MULTSIGNIN(multsignin[i]),         // 1-bit input: Multiplier sign input
                .PCIN(pcin[i]),                     // 48-bit input: P cascade input
                // Control: 4-bit (each) input: Control Inputs/Status Bits
                .ALUMODE(alumode[i]),               // 4-bit input: ALU control input
                .CARRYINSEL(carryinsel[i]),         // 3-bit input: Carry select input
                .CLK(clk[i]),                       // 1-bit input: Clock input
                .INMODE(inmode[i]),                 // 5-bit input: INMODE control input
                .OPMODE(opmode[i]),                 // 7-bit input: Operation mode input
                // Data: 30-bit (each) input: Data Ports
                .A(a[i]),                           // 30-bit input: A data input
                .B(b[i]),                           // 18-bit input: B data input
                .C(c[i]),                           // 48-bit input: C data input
                .CARRYIN(carryin[i]),               // 1-bit input: Carry input signal
                .D(d[i]),                           // 25-bit input: D data input
                // Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
                .CEA1(cea1[i]),                     // 1-bit input: Clock enable input for 1st stage AREG
                .CEA2(cea2[i]),                     // 1-bit input: Clock enable input for 2nd stage AREG
                .CEAD(cead[i]),                     // 1-bit input: Clock enable input for ADREG
                .CEALUMODE(cealumode[i]),           // 1-bit input: Clock enable input for ALUMODE
                .CEB1(ceb1[i]),                     // 1-bit input: Clock enable input for 1st stage BREG
                .CEB2(ceb2[i]),                     // 1-bit input: Clock enable input for 2nd stage BREG
                .CEC(cec[i]),                       // 1-bit input: Clock enable input for CREG
                .CECARRYIN(cecarryin[i]),           // 1-bit input: Clock enable input for CARRYINREG
                .CECTRL(cectrl[i]),                 // 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
                .CED(ced[i]),                       // 1-bit input: Clock enable input for DREG
                .CEINMODE(ceinmode[i]),             // 1-bit input: Clock enable input for INMODEREG
                .CEM(cem[i]),                       // 1-bit input: Clock enable input for MREG
                .CEP(cep[i]),                       // 1-bit input: Clock enable input for PREG
                .RSTA(rsta[i]),                     // 1-bit input: Reset input for AREG
                .RSTALLCARRYIN(rstallcarryin[i]),   // 1-bit input: Reset input for CARRYINREG
                .RSTALUMODE(rstalumode[i]),         // 1-bit input: Reset input for ALUMODEREG
                .RSTB(rstb[i]),                     // 1-bit input: Reset input for BREG
                .RSTC(rstc[i]),                     // 1-bit input: Reset input for CREG
                .RSTCTRL(rstctrl[i]),               // 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
                .RSTD(rstd[i]),                     // 1-bit input: Reset input for DREG and ADREG
                .RSTINMODE(rstinmode[i]),           // 1-bit input: Reset input for INMODEREG
                .RSTM(rstm[i]),                     // 1-bit input: Reset input for MREG
                .RSTP(rstp[i])                      // 1-bit input: Reset input for PREG
            );
        end
    endgenerate

    for (genvar i = 0; i < N-1; i++) begin : g_signs
        assign signOuts[i] = sigsIn[i][24];
    end

endmodule