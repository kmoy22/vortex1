package fp32_utils_pkg;

    // main constants
    localparam int FP32_EXP_BITS  = 8;
    localparam int FP32_FRAC_BITS = 23;
    localparam int FP32_EXP_BIAS  = 127;

    // raw unpack (directly from 32-bit to sign/exp/frac)
    typedef struct packed {
        logic                 sign;
        logic [FP32_EXP_BITS-1:0]  exp;
        logic [FP32_FRAC_BITS-1:0] frac;
    } fp32_raw_t;

    // decoded structure (with implicit bit + flags)
    typedef struct packed {
        logic                sign;
        logic [FP32_EXP_BITS-1:0] exp;          // raw exponent field
        logic signed [9:0]   exp_unbiased;      // after bias (for later int operations)
        logic [FP32_FRAC_BITS:0] mant_norm;     // [24-bit] mantissa with implicit bit (1.xxx or 0.xxx)
        logic                is_zero;
        logic                is_inf;
        logic                is_nan;
        logic                is_subnormal;
    } fp32_dec_t;

    // -------------------------
    // 1) basic unpack
    // -------------------------
    function automatic fp32_raw_t fp32_raw_unpack(input logic [31:0] x);
        fp32_raw_t r;
        r.sign = x[31];
        r.exp  = x[30:23];
        r.frac = x[22:0];
        return r;
    endfunction

    // -------------------------
    // 2) classify + add implicit bit + remove bias
    // -------------------------
    function automatic fp32_dec_t fp32_decode(input logic [31:0] x);
        fp32_dec_t d;
        fp32_raw_t r;

        r = fp32_raw_unpack(x);

        d.sign = r.sign;
        d.exp  = r.exp;

        // classify
        d.is_zero      = (r.exp == '0) && (r.frac == '0);
        d.is_inf       = (r.exp == {FP32_EXP_BITS{1'b1}}) && (r.frac == '0);
        d.is_nan       = (r.exp == {FP32_EXP_BITS{1'b1}}) && (r.frac != '0);
        d.is_subnormal = (r.exp == '0) && (r.frac != '0);

        // mantissa with implicit bit
        if (d.is_zero) begin
            d.mant_norm    = '0;
            d.exp_unbiased = 0;
        end
        else if (d.is_subnormal) begin
            // subnormal: exponent = 1 - bias, mantissa = 0.frac
            d.mant_norm    = {1'b0, r.frac};  // 0.xxx
            d.exp_unbiased = 1 - FP32_EXP_BIAS;
        end
        else if (d.is_inf || d.is_nan) begin
            d.mant_norm    = '0;
            d.exp_unbiased = 0;
        end
        else begin
            // normal: exponent = exp - bias, mantissa = 1.frac
            d.mant_norm    = {1'b1, r.frac};  // 1.xxx
            d.exp_unbiased = $signed({2'b0, r.exp}) - FP32_EXP_BIAS;
        end

        return d;
    endfunction

    // -------------------------
    // 3) pack back to 32-bit (assuming you have handled overflow/rounding)
    //    here is a simple version, can be refined for add/mul later
    // -------------------------
    function automatic logic [31:0] fp32_encode(
        input logic               sign,
        input logic [FP32_EXP_BITS-1:0] exp,
        input logic [FP32_FRAC_BITS-1:0] frac
    );
        logic [31:0] y;
        y = {sign, exp, frac};
        return y;
    endfunction

    // special value constructors (for NaN/Inf/0 later)
    function automatic logic [31:0] fp32_make_zero(input logic sign);
        return {sign, {FP32_EXP_BITS{1'b0}}, {FP32_FRAC_BITS{1'b0}}};
    endfunction

    function automatic logic [31:0] fp32_make_inf(input logic sign);
        return {sign, {FP32_EXP_BITS{1'b1}}, {FP32_FRAC_BITS{1'b0}}};
    endfunction

    function automatic logic [31:0] fp32_make_qnan();
        // quiet NaN: exp = 0xFF, frac MSB = 1
        return {1'b0, {FP32_EXP_BITS{1'b1}}, {1'b1, {FP32_FRAC_BITS-1{1'b0}}}};
    endfunction

endpackage
