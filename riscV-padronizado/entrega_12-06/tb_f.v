// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 31/05/23

// Comandos usados na simulacao (estando no diretorio "SD2"):
//      
//      iverilog -o tb_f .\test_benchs\tb_f.v .\control.v .\risc.v .\mux_three_to_one.v .\ram.v .\datapath.v .\ula.v .\banco_reg.v .\mux_two_to_one.v .\contador_programa.v .\memoria_instrucao.v
//      vvp tb_f
//      gtkwave tb_f.vcd

`timescale 1ns/1ps
module tb_f;
    
    reg clk = 0; 
    reg rst_n;
    
    wire d_mem_we;
    wire [5:0] i_mem_addr;
    wire [5:0] d_mem_addr;
    wire [31:0] i_mem_data;
    wire [63:0] d_mem_data;

    integer i;

    initial begin
        $dumpfile("tb_f.vcd");
        $dumpvars(0,tb_f);
        for(i = 0; i < 32; i = i + 1) begin
            $dumpvars(1, ram.ram[i]);
            $dumpvars(1, fd.banco_reg.registradores[i]);
        end
    end

    always #1 clk = !clk;

    wire [6:0] opcode;              // OpCode direto do IR no FD
    wire rf_we;                     // Habilita escrita na memória de dados e no banco de registradores
    wire [3:0] alu_flags;           // Flags da ULA
    wire [3:0] alu_cmd;             // Operação da ULA
    wire alu_src, pc_src, rf_src;
    uc uc (clk, rst_n, opcode, d_mem_we, rf_we, alu_flags, alu_cmd, alu_src, pc_src, rf_src);
    memoria_instrucao memoria_instrucao(i_mem_addr, i_mem_data);
    ram ram (clk, d_mem_we, d_mem_addr, d_mem_data);

    fd fd (clk, rst_n, opcode, d_mem_we, rf_we, alu_cmd, alu_flags, alu_src, pc_src, rf_src, i_mem_addr, i_mem_data, d_mem_addr, d_mem_data);    

    initial begin

        // test bench do datapath com memoria de instrução e contador de programa:
        #1;
        rst_n = 0;

        #2;
        rst_n = 1;
        #4;
        rst_n = 0;
        #4;
        rst_n = 1;
        #2;
        rst_n = 0;
        #2;
        rst_n = 1;
        
        #500;
        
        #2 $finish;

    end

    initial begin
        $monitor("instruction = %b", i_mem_data);
    end


endmodule