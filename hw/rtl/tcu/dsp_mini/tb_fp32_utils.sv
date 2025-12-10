`timescale 1ns/1ps

import fp32_utils_pkg::*;

module tb_fp32_utils;

    logic [31:0] x;
    fp32_dec_t   d;

    initial begin
        // 1. 1.0f = 0x3F800000
        x = 32'h3F800000;
        d = fp32_decode(x);
        $display("x = %h (1.0)", x);
        $display(" sign=%0d exp=%0d (unbiased=%0d) mant_norm=0x%h zero=%0d inf=%0d nan=%0d sub=%0d",
                 d.sign, d.exp, d.exp_unbiased, d.mant_norm,
                 d.is_zero, d.is_inf, d.is_nan, d.is_subnormal);

        // 2. -2.5f = 0xC0200000
        x = 32'hC0200000;
        d = fp32_decode(x);
        $display("x = %h (-2.5)", x);
        $display(" sign=%0d exp=%0d (unbiased=%0d) mant_norm=0x%h",
                 d.sign, d.exp, d.exp_unbiased, d.mant_norm);

        // 3. +Inf = 0x7F800000
        x = 32'h7F800000;
        d = fp32_decode(x);
        $display("x = %h (+Inf)  nan=%0d inf=%0d", x, d.is_nan, d.is_inf);

        // 4. NaN = 0x7FC00000
        x = 32'h7FC00000;
        d = fp32_decode(x);
        $display("x = %h (NaN)   nan=%0d inf=%0d", x, d.is_nan, d.is_inf);

        // 5. +0.0 = 0x00000000
        x = 32'h00000000;
        d = fp32_decode(x);
        $display("x = %h (+0.0) zero=%0d sub=%0d", x, d.is_zero, d.is_subnormal);

        $finish;
    end

endmodule