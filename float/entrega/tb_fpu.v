`timescale 1ns/1ps
// 2000 ciclos para responder

module tb_fpu;
    reg clk = 0;
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
        reset = 1;
        #2;
        reset = 0;
        start = 1;

        op = 2'b00;

        A = 32'b00111111101000000000000000000000;
        B = 32'b00111111110000000000000000000000;
        // 1,25 + 1,5

        #2;
        start = 0;

        #10;

        start = 0;
        #2;
        start = 1;

        A = 32'b01000010001010101010111000010100;
        B = 32'b01000010000100001100110011001101;
        // 42,67 + 36,2 = 78,87
        #2;
        start = 0;

        #10;

        start = 0;
        #2;
        start = 1;

        A = 32'b00111011101000111101011100001010;
        B = 32'b00111110000011110101110000101001;
        // 0,005 + 0,14 = 0,145
        #2;
        start = 0;

        #10;

        start = 0;
        #2;
        start = 1;

        A = 32'b00111110100010100011110101110001;
        B = 32'b01000000100111110101110000101001;
        // 0,27 + 4,98 = 5,25

        #2;
        start = 0;

        #10;

        start = 0;
        #2;
        start = 1;

        A = 32'b01000000111000000000000000000000;
        B = 32'b01000000111110000000000000000000;
        // 7,0 + 7,75 = 14,75

        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b01000001110011000000000000000000;
        B = 32'b01000001111011000000000000000000;
        // 25,5 + 29,5 = 55

        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b00111111110000000000000000000000;
        B = 32'b00000000000000000000000000000000;
        // 1,5 + 0 = 1,5

        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b11000000001100000000000000000000;
        B = 32'b11000000010100000000000000000000;
        // -2,75 - 3,25 = -6

        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b10111111010000000000000000000000;
        B = 32'b00111110100000000000000000000000;
        // -0,75 + 0,25 = -0,5
        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b01001010100111011111110101110001;
        B = 32'b10111011100111011111110001110001;
        // 5177016,5 - 0,00482135312632 = 5177016,49517864687368
        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b10111111111111111111111111111111;
        B = 32'b11000000111111111111111111111111;
        // -1,99999988079 - 7,99999952316 = -9,99999940395
        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b11000001100111111101101011101100;
        B = 32'b01000010110101010101111111101100;
        // -19,9818954468 + 106,687347412 = 86,7054519652
        #2;
        start = 0;

        #10;
        start = 0;
        #2;
        start = 1;

        A = 32'b01000000010001010101101111000000;
        B = 32'b00111001010101110001010011110000;
        // 3,08372497559 + 0,000205117976293 = 3,083930093566293
        #2;
        start = 0;

        #10;

        // Testa Multiplicação
        start = 0;
        op = 2'b10;
        #2;
        start = 1;

        A = 32'b01000000001000000000000000000000;
        B = 32'b01000000100110000000000000000000;
        // // 2.5 * 4,75 = 11,875
        #2;
        start = 0;
        // 
        #100;

        start = 0;
        #2;
        start = 1;

        A = 32'b10111110000000000000000000000000;
        B = 32'b10111110111000000000000000000000;
        // // -1,125 * -0.4375 = 0.4921875
        #2;
        start = 0;
        // 
        #100;

        start = 0;
        #2;
        start = 1;

        A = 32'b00111111010101000000000000000000;
        B = 32'b11000001010101000000000000000000;
        // // 0.828125 * -13.25 = -10,97265625
        #2;
        start = 0;
        // 
        #100;

        $finish;
    end

    reg [4:0] i;
    initial begin
        i = 0;
    end

    always @(posedge done) begin
        i = i+1;
        $display("%d: A = %b | B = %b | R = %b", i, A, B, R);
    end

    initial begin
        if (done) begin
        end
    end

endmodule