// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

`timescale 1ns/1ps
module tb_banco_reg;
    
    //variaveis de banco reg
    reg clk = 0; 
    reg permisao_escrita;
    reg [4:0] regd, reg1, reg2;
    reg [63:0] din;
    wire [63:0] dout1, dout2;
    integer i;

    initial begin
        $dumpfile("tb_banco_reg.vcd");
        $dumpvars(0,tb_banco_reg);
    end

    always #1 clk = !clk;

    banco_reg banco_reg (clk, permisao_escrita, regd, reg1, reg2, din, dout1, dout2);

    initial begin

        //test bench do banco de registradores:
        permisao_escrita = 0;

        // Checa os valores dos registradores de 0 a 20;
        // Valores iniciais devem ser seus index;
        for (i = 0; i<=10; i=i+1) begin
            #2;
            reg1 = i;
            reg2 = i+10;
        end
        #2;
        permisao_escrita = 1;
        
        // Valores dos registradores ate o index 20 sao multplicados por 3;
        for (i = 0; i<=20; i=i+1) begin
            #2;
            regd = i;
            din = i*3;
        end

        #2;
        permisao_escrita = 0;

        // Checa novos valores nos registradores
        for (i = 0; i<=10; i=i+1) begin
            #2;
            reg1 = i;
            reg2 = i+10;
        end

        #2 $finish;
    end

    initial begin
        $monitor("write_enable = %d | regd = %d | reg1 = %d | reg2 = %d | din = %2d | dout1 = %2d | dout2 = %2d",
                    permisao_escrita, regd, reg1, reg2, din, dout1, dout2);
    end


endmodule