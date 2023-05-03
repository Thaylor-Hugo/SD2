`timescale 1ns/1ps

// Testbench de mux_one_to_three 
module tb_mux_one_to_three;
    
    reg [1:0] op;
    reg [9:0] entrada; 
    wire [9:0] a;
    wire [9:0] b;
    wire [9:0] c;

    initial begin
        $dumpfile("tb_mux_one_to_three.vcd");
        $dumpvars(0,tb_mux_one_to_three);
    end

    mux_one_to_three mux_one_to_three (op, entrada, a, b, c);

    initial begin
        entrada = 10'd2;
        op = 2'b00;
        #2;
        
        entrada = 10'd4;
        op = 2'b01;
        #2;
        
        entrada = 10'd6;
        op = 2'b10;
        #2;
        
        entrada = 10'd8;
        op = 2'b00;
        #2;

        entrada = 10'd10;
        op = 2'b00;
        #2;

        entrada = 10'd12;
        op = 2'b01;
        #2;
        
        #2 $finish;
    end

    initial begin
        $display("\nTeste da mux_one_to_three: \n");
    end
    initial begin
        $monitor("op = %d | entrada = %d | a = %3d | b = %3d | c = %3d", op, entrada, a, b, c);
    end

endmodule