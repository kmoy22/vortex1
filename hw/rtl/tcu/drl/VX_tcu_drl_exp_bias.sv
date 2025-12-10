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

//This module is aimed for fp32 multiplication in 2 DSP slices
// FP32 only version of exponent biasing and preprocessing

//for a pair of input fp32 operands, a and b
//extract exponent exp_a, exp_b
//calculate the exponent of product e_prod_unbiased - exp_a + exp_b - 127
// saturate the result to 0..255
//since only for fp32, the exp_low_larger and raw_exp_diff are not used, set them to 0.

module VX_tcu_drl_exp_bias (
    input wire enable,
    input wire [3:0] fmt_s, //[2:0] or [3:0] maybe  a problem in the future, but not now
    input wire [31:0] a,
    input wire [31:0] b,

    output logic [7:0] raw_exp_y, //per product exponent for DRL
    output logic exp_low_larger, //not used for fp32
    output logic [6:0] raw_exp_diff, //not used for fp32
);

    //NOTE: exception handling neglected for now
    `UNUSED_VAR({enable});

    //extract exponent from a and b
    logic [7:0] exp_a, exp_b;
    assign exp_a = a[30:23];
    assign exp_b = b[30:23];

    //calculate the unbiassed exponent of product
    wire signed [8:0] e_unbiased = $signed({1'b0, exp_a}) + $signed({1'b0, exp_b}) - 9'sd127;

    always_comb begin
        if (e_unbiased < 9'sd0)
            raw_exp_y = 8'd0;
        else if (e_unbiased > 8'd255)
            raw_exp_y = 8'd255;
        else
            raw_exp_y = e_unbiased[7:0];

        exp_low_larger = 1'b0;
        raw_exp_diff = 7'd0;
    end
endmodule