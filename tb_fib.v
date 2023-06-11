// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 31/05/23

// Comandos usados na simulacao (estando no diretorio "SD2"):
//      
//      iverilog -o tb_fib .\test_benchs\tb_fib.v .\control.v .\risc.v .\mux_three_to_one.v .\ram.v .\datapath.v .\ula.v .\banco_reg.v .\mux_two_to_one.v .\contador_programa.v .\memoria_instrucao.v
//      vvp tb_fib
//      gtkwave tb_fib.vcd

`timescale 1ns/1ps
module tb_fib;
    
    // Entrada do RISC
    reg clk = 0; 
    reg reset;
    
    // Saida do RISC
    wire [63:0] program_counter;
    wire [31:0] instrucao;

    integer i;

    initial begin
        $dumpfile("tb_fib.vcd");
        $dumpvars(0,tb_fib);
        for(i = 0; i < 32; i = i + 1) begin
            $dumpvars(1, risc.datapath.ram.ram[i]);
            $dumpvars(1, risc.datapath.banco_reg.registradores[i]);
        end
    end

    always #1 clk = !clk;

    risc risc (clk, reset, program_counter, instrucao);

    initial begin

        // test bench do datapath com memoria de instrução e contador de programa:
        reset = 1;

        #2;
        reset = 0;
        
        #250;
        
        #2 $finish;

    end

    initial begin
        $monitor("program_counter = %2d | instruction = %b", program_counter, instrucao);
    end


endmodule