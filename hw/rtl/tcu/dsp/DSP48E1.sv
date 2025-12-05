// DSP48E1: 48-bit Multi-Functional Arithmetic Block
// Wrapper module for DSP48E1 DPI-C Model
// Identical interface to Xilinx DSP48E1 primitive

module DSP48E1 #(
   // Feature Control Attributes: Data Path Selection
   parameter A_INPUT = "DIRECT",               // Selects A input source, "DIRECT" (A port) or "CASCADE" (ACIN port)
   parameter B_INPUT = "DIRECT",               // Selects B input source, "DIRECT" (B port) or "CASCADE" (BCIN port)
   parameter USE_DPORT = "FALSE",              // Select D port usage (TRUE or FALSE)
   parameter USE_MULT = "MULTIPLY",            // Select multiplier usage ("MULTIPLY", "DYNAMIC", or "NONE")
   parameter USE_SIMD = "ONE48",               // SIMD selection ("ONE48", "TWO24", "FOUR12")

   // Pattern Detector Attributes: Pattern Detection Configuration
   parameter AUTORESET_PATDET = "NO_RESET",    // "NO_RESET", "RESET_MATCH", "RESET_NOT_MATCH"
   parameter MASK = 48'h3fffffffffff,          // 48-bit mask value for pattern detect (1=ignore)
   parameter PATTERN = 48'h000000000000,       // 48-bit pattern match for pattern detect
   parameter SEL_MASK ="MASK",                 // "C", "MASK", "ROUNDING_MODE1", "ROUNDING_MODE2"
   parameter SEL_PATTERN = "PATTERN",          // Select pattern value ("PATTERN" or "C")
   parameter USE_PATTERN_DETECT = "NO_PATDET", // Enable pattern detect ("PATDET" or "NO_PATDET")

   // Register Control Attributes: Pipeline Register Configuration
   parameter ACASCREG = 1,                     // Number of pipeline stages between A/ACIN and ACOUT (0, 1 or 2)
   parameter ADREG = 1,                        // Number of pipeline stages for pre-adder (0 or 1)
   parameter ALUMODEREG = 1,                   // Number of pipeline stages for ALUMODE (0 or 1)
   parameter AREG = 1,                         // Number of pipeline stages for A (0, 1 or 2)
   parameter BCASCREG = 1,                     // Number of pipeline stages between B/BCIN and BCOUT (0, 1 or 2)
   parameter BREG = 1,                         // Number of pipeline stages for B (0, 1 or 2)
   parameter CARRYINREG = 1,                   // Number of pipeline stages for CARRYIN (0 or 1)
   parameter CARRYINSELREG = 1,                // Number of pipeline stages for CARRYINSEL (0 or 1)
   parameter CREG = 1,                         // Number of pipeline stages for C (0 or 1)
   parameter DREG = 1,                         // Number of pipeline stages for D (0 or 1)
   parameter INMODEREG = 1,                    // Number of pipeline stages for INMODE (0 or 1)
   parameter MREG = 1,                         // Number of multiplier pipeline stages (0 or 1)
   parameter OPMODEREG = 1,                    // Number of pipeline stages for OPMODE (0 or 1)
   parameter PREG = 1                          // Number of pipeline stages for P (0 or 1)
)
(
   // Cascade: 30-bit (each) output: Cascade Ports
   output ACOUT[29:0],                   // 30-bit output: A port cascade output
   output BCOUT[17:0],                   // 18-bit output: B port cascade output
   output CARRYCASCOUT,     // 1-bit output: Cascade carry output
   output MULTSIGNOUT,       // 1-bit output: Multiplier sign cascade output
   output PCOUT[47:0],                   // 48-bit output: Cascade output
   // Control: 1-bit (each) output: Control Inputs/Status Bits
   output OVERFLOW,             // 1-bit output: Overflow in add/acc output
   output PATTERNBDETECT, // 1-bit output: Pattern bar detect output
   output PATTERNDETECT,   // 1-bit output: Pattern detect output
   output UNDERFLOW,           // 1-bit output: Underflow in add/acc output
   // Data: 4-bit (each) output: Data Ports
   output CARRYOUT[3:0],             // 4-bit output: Carry output
   output P[47:0],                           // 48-bit output: Primary data output
   // Cascade: 30-bit (each) input: Cascade Ports
   input ACIN[29:0],                     // 30-bit input: A cascade data input
   input BCIN[17:0],                     // 18-bit input: B cascade input
   input CARRYCASCIN,       // 1-bit input: Cascade carry input
   input MULTSIGNIN,         // 1-bit input: Multiplier sign input
   input PCIN[47:0],                     // 48-bit input: P cascade input
   // Control: 4-bit (each) input: Control Inputs/Status Bits
   input ALUMODE[3:0],               // 4-bit input: ALU control input
   input CARRYINSEL[2:0],         // 3-bit input: Carry select input
   input CLK,                       // 1-bit input: Clock input
   input INMODE[4:0],                 // 5-bit input: INMODE control input
   input OPMODE[6:0],                 // 7-bit input: Operation mode input
   // Data: 30-bit (each) input: Data Ports
   input A[29:0],                           // 30-bit input: A data input
   input B[17:0],                           // 18-bit input: B data input
   input C[47:0],                           // 48-bit input: C data input
   input CARRYIN,               // 1-bit input: Carry input signal
   input D[24:0],                           // 25-bit input: D data input
   // Reset/Clock Enable: 1-bit (each) input: Reset/Clock Enable Inputs
   input CEA1,                     // 1-bit input: Clock enable input for 1st stage AREG
   input CEA2,                     // 1-bit input: Clock enable input for 2nd stage AREG
   input CEAD,                     // 1-bit input: Clock enable input for ADREG
   input CEALUMODE,           // 1-bit input: Clock enable input for ALUMODE
   input CEB1,                     // 1-bit input: Clock enable input for 1st stage BREG
   input CEB2,                     // 1-bit input: Clock enable input for 2nd stage BREG
   input CEC,                       // 1-bit input: Clock enable input for CREG
   input CECARRYIN,           // 1-bit input: Clock enable input for CARRYINREG
   input CECTRL,                 // 1-bit input: Clock enable input for OPMODEREG and CARRYINSELREG
   input CED,                       // 1-bit input: Clock enable input for DREG
   input CEINMODE,             // 1-bit input: Clock enable input for INMODEREG
   input CEM,                       // 1-bit input: Clock enable input for MREG
   input CEP,                       // 1-bit input: Clock enable input for PREG
   input RSTA,                     // 1-bit input: Reset input for AREG
   input RSTALLCARRYIN,   // 1-bit input: Reset input for CARRYINREG
   input RSTALUMODE,         // 1-bit input: Reset input for ALUMODEREG
   input RSTB,                     // 1-bit input: Reset input for BREG
   input RSTC,                     // 1-bit input: Reset input for CREG
   input RSTCTRL,               // 1-bit input: Reset input for OPMODEREG and CARRYINSELREG
   input RSTD,                     // 1-bit input: Reset input for DREG and ADREG
   input RSTINMODE,           // 1-bit input: Reset input for INMODEREG
   input RSTM,                     // 1-bit input: Reset input for MREG
   input RSTP                      // 1-bit input: Reset input for PREG
);

// DPI-C Code
   import "DPI-C" function longint dsp48e1_dpi_wrapper(int a1, int a2, int b1, int b2, longint c, int d, byte opmode, byte alumode, byte inmode, byte carryinsel, logic carryin, logic carrycascin);
   import "DPI-C" function logic dsp48e1_carry_dpi_wrapper(int a1, int a2, int b1, int b2, longint c, int d, byte opmode, byte alumode, byte inmode, byte carryinsel, logic carryin, logic carrycascin);

   initial begin
      int a1 = A1;
      int a2 = A2;
      int b1 = B1;
      int b2 = B2;
      int c = C;
      int d = D;
      byte opmode = OPMODE;
      byte alumode = ALUMODE;
      byte inmode = INMODE;
      byte carryinsel = CARRYINSEL;
      logic carryin = CARRYIN;
      logic carrycascin = CARRYCASCIN;

      longint result;
      result = dsp48e1_dpi_wrapper(a1, a2, b1, b2, c, d, opmode, alumode, inmode, carryinsel, carryin, carrycascin);
      logic p_carry;
      p_carry = dsp48e1_carry_dpi_wrapper(a1, a2, b1, b2, c, d, opmode, alumode, inmode, carryinsel, carryin, carrycascin);

      CARRYOUT[3] = p_carry;
      P = result[47:0];
   end

   logic[29:0] A1;
   logic[29:0] A2;
   logic[17:0] B1;
   logic[17:0] B2;

   assign A1 = A_INPUT == "DIRECT" ? A : ACIN;
   assign B1 = B_INPUT == "DIRECT" ? B : BCIN;

   always @(posedge CLK) begin // Model the pipeline registers for A and B inputs
      A2 <= A1;
      B2 <= B1;
   end

   wire unused_ok = &{1'b1,
                      CEA1, CEA2, CEAD, CEALUMODE, CEB1, CEB2, CEC, CECARRYIN, CECTRL, CED, CEINMODE, CEM, CEP,
                      RSTA, RSTALLCARRYIN, RSTALUMODE, RSTB, RSTC, RSTCTRL, RSTD, RSTINMODE, RSTM, RSTP}

   assign ACOUT = 30'b0;
   assign BCOUT = 18'b0;
   assign CARRYCASCOUT = 1'b0;
   assign MULTSIGNOUT = 1'b0;
   assign PCOUT = 48'b0;
   assign OVERFLOW = 1'b0;
   assign PATTERNBDETECT = 1'b0;
   assign PATTERNDETECT = 1'b0;
   assign UNDERFLOW = 1'b0;
   assign CARRYOUT[2:0] = 3'b0;

endmodule

// End of DSP48E1_inst instantiation