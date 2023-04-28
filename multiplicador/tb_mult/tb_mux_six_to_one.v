`timescale 1ns/1ps

// Testbench de mux_six_to_one 
module tb_mux_six_to_one;
    
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [15:0] f;
    reg [2:0] op;
    wire [15:0] saida; 

    initial begin
        $dumpfile("tb_mux_six_to_one.vcd");
        $dumpvars(0,tb_mux_six_to_one);
    end

    mux_six_to_one mux_six_to_one (op, a, b, c, d, e, f, saida);

    initial begin
        a = 15'd1;
        b = 15'd2;
        c = 15'd3;
        e = 15'd4;
        d = 15'd5;
        f = 15'd6;
        op = 3'b000;
        #2;
        
        op = 3'b001;
        #2;

        op = 3'b010;
        #2;

        op = 3'b011;
        #2;

        a = 15'd10;
        b = 15'd20;
        c = 15'd30;
        op = 3'b100;
        #2;

        e = 15'd12;
        d = 15'd15;
        f = 15'd18;
        op = 3'b101;
        #2;
        
        #2 $finish;
    end

    initial begin
        $display("\nTeste da mux_six_to_one: \n");
    end
    initial begin
        $monitor("op = %d | a = %3d | b = %3d | c = %3d | d = %3d | e = %3d | f = %3d | saida = %d", op, a, b, c, d, e, f, saida);
    end

endmodule