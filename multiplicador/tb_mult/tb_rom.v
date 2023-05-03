`timescale 1ns/1ps

// Testbench da rom para leitura das multiplicacoes de 5 bits 
module tb_rom;
    
    reg [4:0] a;
    reg [4:0] b;
    wire [9:0] endereco;
    wire [9:0] leitura; 

    initial begin
        $dumpfile("tb_rom.vcd");
        $dumpvars(0,tb_rom);
    end

    assign endereco = {a, b};
    rom rom (endereco, leitura);

    initial begin
        a = 5'd5;
        b = 5'd10;
        #2;
        
        a = 5'd5;
        b = 5'd0;
        #2;
        
        a = 5'd31;
        b = 5'd31;
        #2;
        
        a = 5'd3;
        b = 5'd8;
        #2;
        
        a = 5'd17;
        b = 5'd15;
        #2;

        #2 $finish;
    end

    initial begin
        $display("\nTeste da rom: \n");
    end
    initial begin
        $monitor("a = %d | b = %d | resultado = %d", a, b, leitura);
    end

endmodule