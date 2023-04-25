// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

`timescale 1ns/1ps
module tb_ram;
    
    //variaveis de ram
    reg clk = 0; 
    reg permisao_escrita;
    reg [63:0] endereco, din;
    wire [63:0] dout;
    integer i;

    initial begin
        $dumpfile("tb_ram.vcd");
        $dumpvars(0,tb_ram);
    end

    always #1 clk = !clk;

    ram ram (clk, permisao_escrita, endereco, din, dout);

    initial begin

        //test bench da ram:

        // Valores iniciais devem ser o proprio index
        for (i = 0; i<=31; i=i+1) begin
            #2;
            permisao_escrita = 0;
            endereco = i;
        end

        // Altera os valores armazenados
        for (i = 0; i<=31; i=i+1) begin
            #2;
            permisao_escrita = 1;
            endereco = i;
            din = (i+10) * 3;
        end

        // Confere se os valores foram alterados
        for (i = 0; i<=31; i=i+1) begin
            #2;
            permisao_escrita = 0;
            endereco = i;
        end
        
        #2 $finish;

    end

    initial begin
        $monitor("write_enable = %d | endereco = %2d | din = %2d | dout = %2d",
                    permisao_escrita, endereco, din, dout);
    end


endmodule