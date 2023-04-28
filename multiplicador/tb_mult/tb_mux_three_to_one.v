`timescale 1ns/1ps

// Testbench de mux_three_to_one 
module tb_mux_three_to_one;
    
    reg [9:0] a;
    reg [9:0] b;
    reg [9:0] c;
    reg [1:0] op;
    wire [9:0] saida; 

    initial begin
        $dumpfile("tb_mux_three_to_one.vcd");
        $dumpvars(0,tb_mux_three_to_one);
    end

    assign endereco = {a, b};
    mux_three_to_one mux_three_to_one (op, a, b, c, saida);

    initial begin
        a = 10'd25;
        b = 10'd42;
        c = 10'd666;
        op = 2'b00;
        #2;
        
        a = 10'd25;
        b = 10'd42;
        c = 10'd666;
        op = 2'b01;
        #2;
        
        a = 10'd25;
        b = 10'd42;
        c = 10'd666;
        op = 2'b10;
        #2;
        
        a = 10'd25;
        b = 10'd42;
        c = 10'd666;
        op = 2'b00;
        #2;

        a = 10'd50;
        b = 10'd84;
        c = 10'd777;
        op = 2'b00;
        #2;

        a = 10'd1;
        b = 10'd2;
        c = 10'd3;
        op = 2'b01;
        #2;
        
        #2 $finish;
    end

    initial begin
        $display("\nTeste da mux_three_to_one: \n");
    end
    initial begin
        $monitor("op = %d | a = %3d | b = %3d | c = %3d | saida = %d", op, a, b, c, saida);
    end

endmodule