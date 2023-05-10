module memoria_instrucao (
    input [63:0] pc,
    output [31:0] instrucao
);
    /* Memoria de instrucao que busca testar uma de cada instrucoes de processador */

    reg [31:0] rom [63:0];  /* 64 espaços de memoria */
    integer i;

    initial begin  
        rom[0] = 32'b0; // Do nothing
        rom[1] = 32'b00000000011100000010000010000011; // load mem[7+reg[0]] into reg[1] -> reg[1] = 7 
        rom[2] = 32'b00000001010100111000111110110011; // add 31$ 7$ 21$    ->  reg[31] = 28
        rom[3] = 32'b01000001111110001000111100110011; // sub 30$ 17$ 31$   ->  reg[30] = -11
        rom[4] = 32'b00000101000100101000111010010011; // addi 29$ 5$ #81   ->  reg[29] = 86
        rom[5] = 32'b00000010101000011000111000011111; // subi 28$ 3$ #42   ->  reg[28] = -39        // nao ha subi on risc v, entao usando combinacao de opcode que nao e usada por outra instrucao
        rom[6] = 32'b00000011110111100010010000100011; // store reg[29] in mem[40+reg[28]] -> mem[1] = 86

        for (i=7; i<64; i=i+1)
            rom[i] = 32'b0;
    end  
    
    /* So devolve uma instrucao se o endereco estiver dentro do tamanho da memoria */
    assign instrucao = (pc[63:0] < 64 )? rom[pc]: 31'd0;

endmodule