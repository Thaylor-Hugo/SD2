`timescale 1ns/1ps

// Testbench de mux_five_to_one 
module tb_mux_five_to_one;
    
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [2:0] op;
    wire [15:0] saida; 

    initial begin
        $dumpfile("tb_mux_five_to_one.vcd");
        $dumpvars(0,tb_mux_five_to_one);
    end

    mux_five_to_one mux_five_to_one (op, a, b, c, d, e, saida);

    initial begin
        a = 10'd1;
        b = 10'd2;
        c = 10'd3;
        d = 10'd4;
        e = 10'd5;
        op = 3'b00;
        #2;
        
        op = 3'b01;
        #2;
        
        op = 3'b10;
        #2;
        
        op = 3'b00;
        #2;

        a = 10'd11;
        b = 10'd12;
        c = 10'd13;
        d = 10'd14;
        e = 10'd15;
        op = 3'b00;
        #2;

        b = 10'd44;
        d = 10'd55;
        op = 3'b11;
        #2;

        a = 10'd1;
        b = 10'd2;
        c = 10'd3;
        d = 10'd4;
        e = 10'd5;
        op = 3'b100;
        #2;
        
        a = 10'd5;
        b = 10'd4;
        c = 10'd3;
        d = 10'd2;
        e = 10'd1;
        op = 3'b100;
        #2;

        #2 $finish;
    end

    initial begin
        $display("\nTeste da mux_five_to_one: \n");
    end
    initial begin
        $monitor("op = %d | a = %3d | b = %3d | c = %3d | d = %3d | e = %3d | saida = %d", 
                    op, a, b, c, d, e, saida);
    end

endmodule