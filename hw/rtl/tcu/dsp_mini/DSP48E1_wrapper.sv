// DSP48E1_wrapper.sv
module DSP48E1_wrapper #(
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
)(
    input logic clk,
    input logic rst,

    // data ports
    input logic [29:0] a,
    input logic [17:0] b,
    input logic [47:0] c,
    input logic [24:0] d,

    //control ports
    input logic [3:0] alumode,
    input logic [6:0] opmode,
    input logic [4:0] inmode,

    //cascade ports
    input logic [29:0] acin,
    input logic [17:0] bcin,
    input logic carrycascin,
    input logic [2:0] carryinsel,
    input logic carryin,

    //main output ports
    output logic [47:0] p,
    output logic [3:0] carryout
);

    //unused ports
    logic [29:0] acout_unused;
    logic [17:0] bcout_unused;
    logic        carrycascout_unused;
    logic        multsignout_unused;
    logic [47:0] pcout_unused;
    logic        overflow_unused;
    logic        patternbdetect_unused;
    logic        patterndetect_unused;
    logic        underflow_unused;

    //instantiate DSP48E1
    DSP48E1 #(
        .A_INPUT(A_INPUT),
        .B_INPUT(B_INPUT),
        .USE_DPORT(USE_DPORT),
        .USE_MULT(USE_MULT),
        .USE_SIMD(USE_SIMD),
        .AUTORESET_PATDET(AUTORESET_PATDET),
        .MASK(MASK),
        .PATTERN(PATTERN),
        .SEL_MASK(SEL_MASK),
        .SEL_PATTERN(SEL_PATTERN),
        .USE_PATTERN_DETECT(USE_PATTERN_DETECT),
        .ACASCREG(ACASCREG),
        .ADREG(ADREG),
        .ALUMODEREG(ALUMODEREG),
        .AREG(AREG),
        .BCASCREG(BCASCREG),
        .BREG(BREG),
        .CARRYINREG(CARRYINREG),
        .CARRYINSELREG(CARRYINSELREG),
        .CREG(CREG),
        .DREG(DREG),
        .INMODEREG(INMODEREG),
        .MREG(MREG),
        .OPMODEREG(OPMODEREG),
        .PREG(PREG)
    ) u_dsp48e1 (
        //clk
        .CLK(clk),

        //data ports
        .A(a),
        .B(b),
        .C(c),
        .D(d),
        .P(p),
        .ACIN(acin),
        .BCIN(bcin),

        //control ports
        .ALUMODE(alumode),
        .OPMODE(opmode),
        .INMODE(inmode),

        //cascade ports
        .CARRYINSEL(carryinsel),
        .CARRYIN(carryin),
        .CARRYOUT(carryout),
        .CARRYCASCIN(carrycascin),

        //predefined ports
        .MULTSIGNIN(1'b0),
        .PCIN('0),

        //reset ports
        .CEA1(1'b1),
        .CEA2(1'b1),
        .CEAD(1'b1),
        .CEALUMODE(1'b1),
        .CEB1(1'b1),
        .CEB2(1'b1),
        .CEC(1'b1),
        .CECARRYIN(1'b1),
        .CECTRL(1'b1),
        .CED(1'b1),
        .CEINMODE(1'b1),
        .CEM(1'b1),
        .CEP(1'b1),

        .RSTA(rst),
        .RSTALLCARRYIN(rst),
        .RSTALUMODE(rst),
        .RSTB(rst),
        .RSTC(rst),
        .RSTCTRL(rst),
        .RSTD(rst),
        .RSTINMODE(rst),
        .RSTM(rst),
        .RSTP(rst),

        //output ports
        .ACOUT(acout_unused),
        .BCOUT(bcout_unused),
        .CARRYCASCOUT(carrycascout_unused),
        .MULTSIGNOUT(multsignout_unused),
        .PCOUT(pcout_unused),
        .OVERFLOW(overflow_unused),
        .PATTERNBDETECT(patternbdetect_unused),
        .PATTERNDETECT(patterndetect_unused),
        .UNDERFLOW(underflow_unused)
    );
endmodule
