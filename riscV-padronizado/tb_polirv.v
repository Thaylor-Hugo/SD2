// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 31/05/23

// Comandos usados na simulacao (estando no diretorio "SD2"):
//      
//      iverilog -o tb_polirv .\test_benchs\tb_polirv.v .\control.v .\risc.v .\mux_three_to_one.v .\ram.v .\datapath.v .\ula.v .\banco_reg.v .\mux_two_to_one.v .\contador_programa.v .\memoria_instrucao.v
//      vvp tb_polirv
//      gtkwave tb_polirv.vcd

`timescale 1ns/1ps
module tb_polirv;
    
    reg clk = 0; 
    reg reset;
    
    wire d_mem_we;
    wire [5:0] i_mem_addr;
    wire [5:0] d_mem_addr;
    wire [31:0] i_mem_data;
    wire [63:0] d_mem_data;

    integer i;

    initial begin
        $dumpfile("tb_polirv.vcd");
        $dumpvars(0,tb_polirv);
        for(i = 0; i < 32; i = i + 1) begin
            $dumpvars(1, ram.ram[i]);
            $dumpvars(1, polirv.fd.banco_reg.registradores[i]);
        end
    end

    always #1 clk = !clk;

    polirv polirv (clk, reset, i_mem_addr, i_mem_data, d_mem_we, d_mem_addr, d_mem_data);
    memoria_instrucao memoria_instrucao(i_mem_addr, i_mem_data);
    ram ram (clk, d_mem_we, d_mem_addr, d_mem_data);

    initial begin

        // test bench do datapath com memoria de instrução e contador de programa:
        reset = 1;

        #2;
        reset = 0;
        
        #250;
        
        #2 $finish;

    end

    initial begin
        $monitor("instruction = %b", i_mem_data);
    end


endmodule