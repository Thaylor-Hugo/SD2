// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

`timescale 1ns/1ps
module tb_registrador;
    
    reg [15:0] a; 
    reg load;
    reg clk = 0;
    wire [15:0] leitura;
    
    initial begin
        $dumpfile("tb_registrador.vcd");
        $dumpvars(0,tb_registrador);
    end

    always #1 clk = !clk;

    registrador registrador(clk, load, a, leitura);

    initial begin
        
        #1;

        a = 15'd32;
        load = 1;
        
        #2;
        a = 15'd85;

        #2;
        load = 0;
        a = 15'd74;
        
        #2;
        load = 1;
        a = 15'd42;

        #2 $finish;

    end

    initial begin
        $monitor("load = %d | a = %d | leitura = %d", load, a, leitura);
    end


endmodule