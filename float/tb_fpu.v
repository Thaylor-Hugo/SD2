`timescale 1ns/1ps
module tb_fpu;
    reg clk;
    reg reset;

    initial begin
        $dumpfile("tb_fpu.vcd");
        $dumpvars(0,tb_fpu);
    end

    always #1 clk = !clk;

    reg [31:0] A, B;
    reg [1:0] op;
    reg start;
    wire [31:0] R;
    wire done;

    fpu fpu (clk, reset, A, B, R, op, start, done);

    initial begin
        #1;
        reset = 0;
        start = 1;

        op = 2'b00;

        A = 32'b00111111101000000000000000000000;
        B = 32'b00111111101000000000000000000000;

        #100;

    end

    initial begin
        $monitor("A = %b | B = %b | R = %b", A, B, R);
    end
    
endmodule