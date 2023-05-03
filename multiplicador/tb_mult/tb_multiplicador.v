`timescale 1ns/1ps

// Testbench de multiplicador de entradas 8 bits com resultado de 16 bits
module tb_multiplicador;
    
    reg start = 0;
    reg clk = 0;
    reg [7:0] a, b;
    wire [15:0] result;
    wire done;
    integer i; 
    integer j; 

    initial begin
        $dumpfile("tb_multiplicador.vcd");
        $dumpvars(0,tb_multiplicador);
    end

    always #1 clk = !clk;

    multiplicador multiplicador (clk, start, a, b, done, result);

    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                start = 0;
                #2;
                start = 1;
                a = i;
                b = j;
                #10;
            end
        end
        #2;
        $finish;
    end

    initial begin
        $display("\nTeste do multiplicador: \n\n");
    end
    initial begin
        $monitor("done = %d | a = %d | b = %d | resultado = %d", done, a, b, result);
    end

endmodule