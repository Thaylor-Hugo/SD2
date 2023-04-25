// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Comandos usados na simulacao:
//      
//      iverilog -o tb_rf .\test_benchs\tb_rf.v .\ram.v .\rf.v .\somador.v .\banco_reg.v
//      vvp tb_rf
//      gtkwave tb_rf.vcd

`timescale 1ns/1ps
module tb_datapath;
    
    //variaveis de rf
    reg clk = 0; 
    reg enable = 0;
    reg [4:0] a, b, w;
    reg load_store;
    reg [63:0] din;
    wire [63:0] douta, doutb;

    initial begin
        $dumpfile("tb_datapath.vcd");
        $dumpvars(0,tb_datapath);
    end

    always #1 clk = !clk;

    rf rf (clk, enable, a, b, din, load_store, w, douta, doutb);

    initial begin

        //test bench do load e do store:
        enable = 1;

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
        
        #2;
        enable = 0;

        // Checa se as operacoes funcionaram pelos valores esperados nos registradores

        #2;
        a=5'd2; // reg[2] = 16
        b=5'd3; // reg[3] = 31

        #2;
        a=5'd30; // reg[30] = 2
        b=5'd31; // reg[31] = 4
    
        #2 $finish;

    end

    initial begin
        $monitor("enable = %d | load_store = %d | a = %d | b = %d | w = %d | din = %2d | douta = %2d | doutb = %2d",
                    enable, load_store, a, b, w, din, douta, doutb);
    end


endmodule