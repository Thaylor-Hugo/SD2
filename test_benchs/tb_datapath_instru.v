// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 10/05/23

// Comandos usados na simulacao (estando no diretorio "SD2"):
//      
//      iverilog -o tb_datapath_instru .\test_benchs\tb_datapath_instru.v .\ram.v .\datapath.v .\ula.v .\banco_reg.v .\mux_two_to_one.v .\contador_programa.v .\memoria_instrucao.v
//      vvp tb_datapath_instru
//      gtkwave tb_datapath_instru.vcd

// OUTDATED

`timescale 1ns/1ps
module tb_datapath_instru;
    
    // Entrada do datapath
    reg clk = 0; 
    reg reset;
    reg load_en;
    reg store_en;
    reg [1:0] op_ula;
    reg operation_type;
    reg ula_entry;
    reg branch;
    reg sign;

    // Saida do datapath
    wire [63:0] program_counter;
    wire [31:0] instrucao;

    integer i;

    initial begin
        $dumpfile("tb_datapath_instru.vcd");
        $dumpvars(0,tb_datapath_instru);
        for(i = 0; i < 32; i = i + 1) begin
            $dumpvars(1, datapath.ram.ram[i]);
            $dumpvars(1, datapath.banco_reg.registradores[i]);
        end
    end

    always #1 clk = !clk;

    datapath datapath (clk, reset, load_en, store_en, op_ula, operation_type, ula_entry, branch, sign, program_counter, instrucao);

    initial begin

        // test bench do datapath com memoria de instrução e contador de programa:
        reset = 1;

        #2; // load mem[7+reg[0]] into reg[1] -> reg[1] = 7
        reset = 0;
        load_en = 1;
        store_en = 0;
        operation_type = 0;
        ula_entry = 0;
        op_ula = 2'b01;
        branch = 0;
        sign = 0;
        
        #2; // add 31$ 7$ 21$    ->  reg[31] = 28
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b01;
        
        #2; // sub 30$ 17$ 31$   ->  reg[30] = -14
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b00;
        
        #2; // addi 29$ 5$ #81   ->  reg[29] = 86
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 0;
        op_ula = 2'b01;
        
        #2; // subi 28$ 3$ #42   ->  reg[28] = -39
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 0;
        op_ula = 2'b00;
        
        #2; // store reg[29] in mem[40+reg[28]] -> mem[1] = 86
        load_en = 0;
        store_en = 1;
        operation_type = 0;
        ula_entry = 0;
        op_ula = 2'b01;
        
        // instrucoes branch

        #2; // beq 1$ 7$ #3 -> vai pro pc = 10
        load_en = 0;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b10;
        branch = 1;
        sign = 1;
        
        #2; // bne 30$ 31$ #-2 -> vai pro pc = 8
        load_en = 0;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b10;
        
        #2; // bgt 29$ 30$ #3 -> vai pro pc = 11
        load_en = 0;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b11;
        
        #2; // blt 0$ $15 #-2  -> vai pro pc = 9
        load_en = 0;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b11;
        
        #2; // bgtu 28$ 17$ #3  -> vai pro pc = 12
        load_en = 0;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b11;
        sign = 0;
        
        #2; // bltu 13$ 30$ #2 -> vai pro pc = 14
        load_en = 0;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        op_ula = 2'b11;

        #2;

        #2 $finish;

    end

    initial begin
        $monitor("program_counter = %2d | instruction = %b", program_counter, instrucao);
    end


endmodule