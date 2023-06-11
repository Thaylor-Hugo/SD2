module memoria_instrucao (
    input [63:0] pc,
    output [31:0] instrucao
);
    /* Memoria de instrucao que busca testar uma de cada instrucoes de processador */

    reg [31:0] rom [63:0];  /* 64 espaços de memoria */
    integer i;

    initial begin  
        rom[0] = 32'b0; // Do nothing
        rom[1] = 32'b00000000000100000010000100000011; // load mem[1+reg[0]] into reg[2] -> reg[2] = 1 
        rom[2] = 32'b00000000001000001000001000110011; // add 1$ 2$ 4$
        rom[3] = 32'b00000000001000000000000010110011; // add 0$ 2$ 1$
        rom[4] = 32'b00000000010000000000000100110011; // add 0$ 4$ 2$
        rom[5] = 32'b00000000000100011000000110010011; // addi 3$ 1# 3$
        rom[6] = 32'b11111110100000011100110011100011; // blt 3$ $6 #-4
        rom[7] = 32'b11111110100000011000101111100011; // beq 3$ 6$ #-5
        rom[8] = 32'b00000000001000000010000010100011; // store reg[2] into mem[1+reg[0]]
        
        // 1111111 01000 00011 100 11001 1100011
        // 1111111 01000 00011 000 10111 1100011
        for (i=9; i<64; i=i+1)
            rom[i] = 32'b0;
    end  
    
    /* So devolve uma instrucao se o endereco estiver dentro do tamanho da memoria */
    assign instrucao = (pc[63:0] < 64 )? rom[pc]: 31'd0;

endmodule