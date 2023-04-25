// Test bench do mux
`timescale 1ns/1ps
module tb_mux_two_to_one;

    reg [63:0] a;
    reg [63:0] b;
    reg op;
    wire [63:0] out;

    initial begin
        $dumpfile("tb_mux_two_to_one.vcd");
        $dumpvars(0,tb_mux_two_to_one);
    end

    mux_two_to_one mux_two_to_one (op, a, b, out);

    initial begin
        op = 1;
        a = 64'd55;
        b = 64'd27;
        #2;
        op = 1;
        a = 64'd73;
        b = 64'd42;
        #2;
        op = 0;
        a = 64'd55;
        b = 64'd27;
        #2;
        op = 1;
        a = 64'd55;
        b = 64'd27;
        #2;
        op = 0;
        a = 64'd98;
        b = 64'd12;
        #2;
    end

    initial begin
        $monitor("a = %2d | b = %2d | op = %d | out = %2d",
                    a, b, op, out);
    end

endmodule