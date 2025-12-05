// mini_test.sv


module tb_mini_wrapper;
    logic clk = 0;
    logic rst = 1;

    always #5 clk <= ~clk;

    logic [29:0] a;
    logic [17:0] b;
    logic [47:0] c;
    logic [24:0] d;

    logic [3:0] alumode;
    logic [6:0] opmode;
    logic[4:0] inmode;

    logic [29:0] acin;
    logic [17:0] bcin;
    logic carrycascin;
    logic [2:0] carryinsel;
    logic carryin;

    logic [47:0] p;
    logic [3:0] carryout;

    DSP48E1_wrapper DUT (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .alumode(alumode),
        .opmode(opmode),
        .inmode(inmode),
        .acin(acin),
        .bcin(bcin),
        .carrycascin(carrycascin),
        .carryinsel(carryinsel),
        .carryin(carryin),
        .p(p),
        .carryout(carryout)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_mini_wrapper);

        //reset
        a = '0; b = '0; c = '0; d = '0;
        alumode = 4'b0000; opmode = 7'b0110101; inmode = 5'b00000;
        acin = '0; bcin = '0; carrycascin = 1'b0; carryinsel = 3'b000; carryin = 1'b0;

        #20 rst = 0;

        // A = 3, B = 4, C = 5, D = 0 ---p = 3*4+5 = 17
        @(posedge clk);
        a = 30'd3; b = 18'd4; //c = 48'd5; d = 25'd0;

        //wait
        repeat (10) @(posedge clk);
        $display ("P = %0d (expected 17)", p);
        if (p != 48'd17) begin
            $fatal("wrapper/DSP48E1 stub mismatch!");
        end
        else begin
            $display("wrapper basic test passed.");
        end

        $finish;
    end
endmodule
