// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 19/04/23   -> nota: alterado para testar operacoes de add e sub tambem

// Comandos usados na simulacao:
//      
//      iverilog -o tb_datapath .\test_benchs\tb_datapath.v .\ram.v .\tb_datapath.v .\somador.v .\banco_reg.v .\mux_two_to_one.v
//      vvp tb_datapath
//      gtkwave tb_datapath.vcd


// OUTDATED

`timescale 1ns/1ps
module tb_datapath;
    
    //variaveis de rf
    reg clk = 0; 
    reg enable = 0;
    reg [4:0] a, b, w;
    reg load_store;
    reg signed [63:0] din;

    // adicionados para adicicao de operacoes de add e sub
    reg op_ula;
    reg operation_type;
    reg ula_entry;

    wire signed [63:0] douta, doutb;

    initial begin
        $dumpfile("tb_datapath.vcd");
        $dumpvars(0,tb_datapath);
    end

    always #1 clk = !clk;

    datapath datapath (clk, enable, a, b, din, load_store, op_ula, operation_type, ula_entry, w, douta, doutb);

    initial begin

        //test bench do load e do store:
        enable = 1;
        op_ula = 1;
        operation_type = 0;
        ula_entry = 0;

        #2; // store value of reg[2] in mem[0+reg[0]] -> mem[0] = 2;
        load_store=0;
        din= 64'd0;
        a= 5'd2;
        b= 5'd0;

        #2; // store value of reg[4] in mem[2+reg[6]] -> mem[8] = 4;
        din= 64'd2;
        a= 5'd4;
        b= 5'd6;

        #2; // load value of mem[3+reg[13]] into reg[2] -> reg[2] = 16
        load_store=1;
        din= 64'd3;
        w=  5'd2;
        b=  5'd13;

        #2; // load value of mem[10+reg[21]] into reg[3] -> reg[3] = 31
        load_store=1;
        din= 64'd10;
        w=  5'd3;
        b=  5'd21;

        #2; // load value of mem[0+reg[0]] into reg[30] -> reg[30] = 2
        load_store=1;
        din= 64'd0;
        w=  5'd30;
        b=  5'd0;

        #2; // load value of mem[8+reg[0]] into reg[31] -> reg[31] = 4
        load_store=1;
        din= 64'd8;
        w=  5'd31;
        b=  5'd0;

        // Testbench para operacoes de add e sub com imm    (regW = regB +- imm)
        #2;
        load_store = 1;
        operation_type = 1;
        ula_entry = 0;
        op_ula = 1;
        
        din = -64'd85;
        b = 5'd3;
        w = 5'd15;

        #2;
        op_ula = 0;
        din = -64'd42;
        b = 5'd0;
        w = 5'd16;

        // Testbench para operacoes de add e sub    (regW = regB +- regA)
        #2;
        ula_entry = 1;
        op_ula = 1;
        b = 5'd15;
        a = 5'd16;
        w = 5'd17;

        #2;
        op_ula = 0;
        b = 5'd0;
        a = 5'd3;
        w = 5'd18;

        #2;
        op_ula = 1;
        b = 5'd17;
        a = 5'd18;
        w = 5'd19;

        #2;
        op_ula = 0;
        b = 5'd16;
        a = 5'd27;
        w = 5'd20;
        
        #2;
        op_ula = 1;
        b = 5'd12;
        a = 5'd17;
        w = 5'd21;

        // Checa se as operacoes funcionaram pelos valores esperados nos registradores
        // Operacoes de load e store 
        
        #2;
        enable = 0;
        a=5'd2; // reg[2] = 16
        b=5'd3; // reg[3] = 31

        #2;
        a=5'd30; // reg[30] = 2
        b=5'd31; // reg[31] = 4

        // operacoes de add e sub com imm

        #2;
        a=5'd15; // reg[15] = -54
        b=5'd16; // reg[16] = 42

        // Operacoes de add e sub

        #2;
        a=5'd17; // reg[17] = -12
        b=5'd18; // reg[18] = -31
        
        #2;
        a=5'd19; // reg[19] = -43
        b=5'd20; // reg[20] = 15
    
        #2;
        a=5'd19; // reg[19] = -43
        b=5'd21; // reg[21] = 0
        #2 $finish;

    end

    initial begin
        $monitor("enable = %d | load_store = %d | a = %d | b = %d | w = %d | din = %2d | douta = %2d | doutb = %2d",
                    enable, load_store, a, b, w, din, douta, doutb);
    end


endmodule