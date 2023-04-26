// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 26/04/23

// Comandos usados na simulacao:
//      
//      iverilog -o tb_dataflow_add_sub .\test_benchs\tb_dataflow_add_sub.v .\ram.v .\datapath.v .\somador.v .\banco_reg.v .\mux_two_to_one.v
//      vvp tb_dataflow_add_sub
//      gtkwave tb_dataflow_add_sub.vcd

`timescale 1ns/1ps
module tb_dataflow_add_sub;
    
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
        $dumpfile("tb_dataflow_add_sub.vcd");
        $dumpvars(0,tb_dataflow_add_sub);
    end

    always #1 clk = !clk;

    datapath datapath (clk, enable, a, b, din, load_store, op_ula, operation_type, ula_entry, w, douta, doutb);

    initial begin

        // Setup load:
        enable = 1;
        op_ula = 1;
        operation_type = 0;
        ula_entry = 0;

        #2; // load value of mem[7+reg[0]] into reg[1] -> reg[1] = 7
        load_store=1;
        din= 64'd7;
        w=  5'd1;
        b=  5'd0;

        #2; // load value of mem[9+reg[0]] into reg[2] -> reg[2] = 9
        load_store=1;
        din= 64'd9;
        w=  5'd2;
        b=  5'd0;

        // Setup add/sub operation
        #2;
        load_store = 1;
        operation_type = 1;
        ula_entry = 1;

        // add X3, X2, X1
        op_ula = 1;
        b = 5'd1;
        a = 5'd2;
        w = 5'd3;

        #2; // sub X4, X3, X1
        op_ula = 0;
        b = 5'd3;
        a = 5'd1;
        w = 5'd4;

        // Setup store operation
        #2; 
        load_store=0;
        op_ula = 1;
        operation_type = 0;
        ula_entry = 0;

        // store value of reg[3] in mem[3+reg[0]] -> mem[3] = 16; 
        din= 64'd3;
        a= 5'd3;
        b= 5'd0;

        #2; // store value of reg[4] in mem[4+reg[0]] -> mem[4] = 9;
        din= 64'd4;
        a= 5'd4;
        b= 5'd0;

        #2;
        // Para verificar operacao de store, os valores armazenados foram carregados em registradores        
        op_ula = 1;
        operation_type = 0;
        ula_entry = 0;
        
        // load value of mem[3+reg[0]] into reg[31] -> reg[31] = 16
        load_store=1;
        din= 64'd3;
        w=  5'd31;
        b=  5'd0;

        #2; // load value of mem[4+reg[0]] into reg[30] -> reg[30] = 9
        load_store=1;
        din= 64'd4;
        w=  5'd30;
        b=  5'd0;

        // Checa se as operacoes funcionaram pelos valores esperados nos registradores
        
        // Operacoes de load 
        #2;
        enable = 0;
        a=5'd1; // reg[1] = 7
        b=5'd2; // reg[2] = 9

        // Operacoes de add e sub 
        #2;
        a=5'd3; // reg[3] = 16
        b=5'd4; // reg[4] = 9

        // Operacao de store
    
        #2;
        enable = 0;
        a=5'd30; // reg[30] = 9
        b=5'd31; // reg[31] = 16

        #2 $finish;

    end

    initial begin
        $display("\nCheca se as operacoes funcionaram pelos valores esperados nos registradores:");
        $display("reg[1]  =  7  | reg[2]  =  9 ");
        $display("reg[3]  =  16 | reg[4]  =  9 ");
        $display("reg[30] =  9  | reg[31] =  16");
        $display("\n-----------------------------\n");
        $display("Valores do monitor: \n");
        #19;
        $monitor("regA = %d | regB = %d | doutA = %2d | doutB = %2d",
                    a, b, douta, doutb);
    end


endmodule