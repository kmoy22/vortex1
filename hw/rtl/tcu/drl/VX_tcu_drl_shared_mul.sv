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

// This module is used to multiply two fp32 operands
// following IEEE 754 format, extract sign_a, sign_b, exp_a, exp_b, frac_a, frac_b
//form 24-bit mantissa multiplication mant_a, mant_b
// using 2 DSP48e1 to do the mantissa multiplication
//mant_a * mant_b = mant_a * b_low + (mant_a * b_high) << 18
//take the highest 24 bits and combined with calculated sign_bit
//return the result in 25-bit

module VX_txu_drl_shared_mul (
    input logic clk,
    input logic reset,
    input logic enable,

    input logic [3:0] fmt_s,
    input logic [31:0] a,
    input logic [31:0] b,

    output logic [24:0] y,
);

// extract sign, exp, frac from a and b
logic sign_a, sign_b, sign_p;
logic [7:0] exp_a, exp_b;
logic [22:0] frac_a, frac_b;

assign sign_a = a[31];
assign sign_b = b[31];
assign sign_p = sign_a ^ sign_b;

assign exp_a = a[30:23];
assign exp_b = b[30:23];
assign frac_a = a[22:0];
assign frac_b = b[22:0];

//calculate the mantissa
logic [23:0] mant_a, mant_b;

assign mant_a = {1'b1, frac_a};
assign mant_b = {1'b1, frac_b};

// split the mant_b into low and high parts, 2 pieces of DSP48e1
//b_lo = mant_b[17:0], b_hi = mant_b[23:18]

logic [17:0] b_lo;
logic [17:0] b_hi_ext;

assign b_lo = mant_b[17:0];
assign b_hi_ext = {12'b0, mant_b[23:18]};

logic [24:0] a_ext;
assign a_ext = {1'b0, mant_a};

// 2 DSP48e1 to do the multiplication

    // ------------------------------------------------------------------------
    // 3. DSP control constants
    //    according to the configuration in dsp48e1.c:
    //      - multiplication:      OPMODE = 0000101, ALUMODE = 0000, INMODE = 00000
    //      - A*B + C:     OPMODE = 0110101, same as above
    // ------------------------------------------------------------------------

    localparam [6:0] OPMODE_MUL     = 7'b0000101; // P = A * B
    localparam [6:0] OPMODE_MUL_ADD = 7'b0110101; // P = A * B + C
    localparam [3:0] ALUMODE_ADD    = 4'b0000;
    localparam [4:0] INMODE_DIRECT  = 5'b00000;
    localparam [2:0] CARRYINSEL_ZERO= 3'b000;

    // ------------------------------------------------------------------------
    // 4. two DSPs: first calculate p_lo = A * b_lo, then calculate p_hi = A * b_hi_ext + (p_lo << 18)
    // ------------------------------------------------------------------------

    logic [47:0] p_lo;
    logic [47:0] p_hi;

    // DSP0: p_lo = A_ext * b_lo
    DSP48E1 dsp_mul_lo (
        // Cascade outputs (unused)
        .ACOUT       (),
        .BCOUT       (),
        .CARRYCASCOUT(),
        .MULTSIGNOUT (),
        .PCOUT       (),
        // Status outputs (unused)
        .OVERFLOW    (),
        .PATTERNBDETECT(),
        .PATTERNDETECT(),
        .UNDERFLOW   (),
        .CARRYOUT    (),
        .P           (p_lo),

        // Cascade inputs (unused)
        .ACIN        (30'd0),
        .BCIN        (18'd0),
        .CARRYCASCIN (1'b0),
        .MULTSIGNIN  (1'b0),
        .PCIN        (48'd0),

        // Control
        .ALUMODE     (ALUMODE_ADD),
        .CARRYINSEL  (CARRYINSEL_ZERO),
        .CLK         (clk),
        .INMODE      (INMODE_DIRECT),
        .OPMODE      (OPMODE_MUL),

        // Data
        .A           ({5'd0, a_ext}),  // A is 30 bit, a_ext put the lower 25 bits
        .B           (b_lo),
        .C           (48'd0),
        .CARRYIN     (1'b0),
        .D           (25'd0),

        // Clock enables：here simply raise all, use enable also can
        .CEA1        (enable),
        .CEA2        (enable),
        .CEAD        (enable),
        .CEALUMODE   (enable),
        .CEB1        (enable),
        .CEB2        (enable),
        .CEC         (enable),
        .CECARRYIN   (enable),
        .CECTRL      (enable),
        .CED         (enable),
        .CEINMODE    (enable),
        .CEM         (enable),
        .CEP         (enable),

        // Resets
        .RSTA        (reset),
        .RSTALLCARRYIN(reset),
        .RSTALUMODE  (reset),
        .RSTB        (reset),
        .RSTC        (reset),
        .RSTCTRL     (reset),
        .RSTD        (reset),
        .RSTINMODE   (reset),
        .RSTM        (reset),
        .RSTP        (reset)
    );

    // to align the timing, delay p_lo by one cycle (optional, but more stable)
    logic [47:0] p_lo_r;
    always_ff @(posedge clk) begin
        if (reset) begin
            p_lo_r <= '0;
        end else if (enable) begin
            p_lo_r <= p_lo;
        end
    end

    // C = p_lo_r << 18
    logic [47:0] c_hi;
    assign c_hi = p_lo_r << 18;

    // DSP1: p_hi = A_ext * b_hi_ext + (p_lo_r << 18)
    DSP48E1 dsp_mul_hi (
        // Cascade outputs (unused)
        .ACOUT       (),
        .BCOUT       (),
        .CARRYCASCOUT(),
        .MULTSIGNOUT (),
        .PCOUT       (),
        // Status outputs (unused)
        .OVERFLOW    (),
        .PATTERNBDETECT(),
        .PATTERNDETECT(),
        .UNDERFLOW   (),
        .CARRYOUT    (),
        .P           (p_hi),

        // Cascade inputs (unused here)
        .ACIN        (30'd0),
        .BCIN        (18'd0),
        .CARRYCASCIN (1'b0),
        .MULTSIGNIN  (1'b0),
        .PCIN        (48'd0),

        // Control
        .ALUMODE     (ALUMODE_ADD),
        .CARRYINSEL  (CARRYINSEL_ZERO),
        .CLK         (clk),
        .INMODE      (INMODE_DIRECT),
        .OPMODE      (OPMODE_MUL_ADD),  // A*B + C

        // Data
        .A           ({5'd0, a_ext}),
        .B           (b_hi_ext),
        .C           (c_hi),            // p_lo_r << 18
        .CARRYIN     (1'b0),
        .D           (25'd0),

        // Clock enables
        .CEA1        (enable),
        .CEA2        (enable),
        .CEAD        (enable),
        .CEALUMODE   (enable),
        .CEB1        (enable),
        .CEB2        (enable),
        .CEC         (enable),
        .CECARRYIN   (enable),
        .CECTRL      (enable),
        .CED         (enable),
        .CEINMODE    (enable),
        .CEM         (enable),
        .CEP         (enable),

        // Resets
        .RSTA        (reset),
        .RSTALLCARRYIN(reset),
        .RSTALUMODE  (reset),
        .RSTB        (reset),
        .RSTC        (reset),
        .RSTCTRL     (reset),
        .RSTD        (reset),
        .RSTINMODE   (reset),
        .RSTM        (reset),
        .RSTP        (reset)
    );

    // ------------------------------------------------------------------------
    // 5. take the highest 24 bits from the 48-bit product to form the magnitude, and combine with sign to form the 25-bit mantissa
    //    note: here is the raw mantissa, the real normalize/round is done in the later norm_round stage
    // ------------------------------------------------------------------------

    logic [23:0] mag_fp32;

    always_ff @(posedge clk) begin
        if (reset) begin
            mag_fp32 <= '0;
            y        <= '0;
        end else if (enable) begin
            // here simply take the highest 24 bits (can be adjusted according to the implementation of the later norm_round stage)
            mag_fp32 <= p_hi[47 -: 24];
            y        <= {sign_p, mag_fp32};
        end
    end

endmodule