`timescale 1ns/1ps

// Testbench de mux_one_to_six 
module tb_mux_one_to_six;
    
    reg [2:0] op;
    reg [15:0] entrada; 
    wire [15:0] a;
    wire [15:0] b;
    wire [15:0] c;
    wire [15:0] d;
    wire [15:0] e;
    wire [15:0] f;

    initial begin
        $dumpfile("tb_mux_one_to_six.vcd");
        $dumpvars(0,tb_mux_one_to_six);
    end

    mux_one_to_six mux_one_to_six (op, entrada, a, b, c, d, e, f);

    initial begin
        entrada = 15'd1;
        op = 3'b000;
        #2;
        
        entrada = 15'd1;
        op = 3'b001;
        #2;
        
        entrada = 15'd2;
        op = 3'b010;
        #2;
        
        entrada = 15'd3;
        op = 3'b011;
        #2;

        entrada = 15'd4;
        op = 3'b100;
        #2;

        entrada = 15'd5;
        op = 3'b101;
        #2;

        entrada = 15'd5;
        op = 3'b011;
        #2;

        entrada = 15'd8;
        op = 3'b000;
        #2;
        
        #2 $finish;
    end

    initial begin
        $display("\nTeste da mux_one_to_six: \n");
    end
    initial begin
        $monitor("op = %d | entrada = %d | a = %3d | b = %3d | c = %3d | d = %3d | e = %3d | f = %3d",
                    op, entrada, a, b, c, d, e, f);
    end

endmodule