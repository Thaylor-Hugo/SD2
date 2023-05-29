// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 31/05/23

// Comandos usados na simulacao (estando no diretorio "SD2"):
//      
//      iverilog -o tb_risc .\test_benchs\tb_risc.v .\control.v .\risc.v .\mux_three_to_one.v .\ram.v .\datapath.v .\ula.v .\banco_reg.v .\mux_two_to_one.v .\contador_programa.v .\memoria_instrucao.v
//      vvp tb_risc
//      gtkwave tb_risc.vcd

`timescale 1ns/1ps
module tb_risc;
    
    // Entrada do RISC
    reg clk = 0; 
    reg reset;
    
    // Saida do RISC
    wire [63:0] program_counter;
    wire [31:0] instrucao;

    integer i;

    initial begin
        $dumpfile("tb_risc.vcd");
        $dumpvars(0,tb_risc);
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

        #2; // load mem[7+reg[0]] into reg[1] -> reg[1] = 7
        reset = 0;
        
        #2; // add 31$ 7$ 21$    ->  reg[31] = 28
        
        #2; // sub 30$ 17$ 31$   ->  reg[30] = -14
        
        #2; // addi 29$ 5$ #81   ->  reg[29] = 86
        
        #2; // subi 28$ 3$ #42   ->  reg[28] = -39
        
        #2; // store reg[29] in mem[40+reg[28]] -> mem[1] = 86
        
        // instrucoes branch

        #2; // beq 1$ 7$ #3 -> vai pro pc = 10
        
        #2; // bne 30$ 31$ #-2 -> vai pro pc = 8
        
        #2; // bgt 29$ 30$ #3 -> vai pro pc = 11
        
        #2; // blt 0$ $15 #-2  -> vai pro pc = 9
        
        #2; // bgtu 28$ 17$ #3  -> vai pro pc = 12
        
        #2; // bltu 13$ 30$ #2 -> vai pro pc = 15

        #2; // jal $27 #-2 -> salva pc+1 no reg[27] e pula pro pc = 13

        #2; // auipc $26 #0 -> reg[26] = pc = 13

        #2; // jalr $25 $26 #5 -> reg[25] = pc+1 = 14 e pc = reg[26] + imm = 18

        #2; // bgt 29$ 30$ #3 -> vai pro pc = 11    
        
        #2; // bltu 0$ $15 #-2  -> vai pro pc = 9

        #2; // bne 0$ $15 #-2  -> vai pro pc = 9

        #2;

        #2 $finish;

    end

    initial begin
        $monitor("program_counter = %2d | instruction = %b", program_counter, instrucao);
    end


endmodule