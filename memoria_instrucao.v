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
        rom[7] = 32'b00000000011100001000001101100011;  // beq 1$ 7$ #3 -> vai pro pc = 10
        rom[8] = 32'b00000001111011101101001101100011;  // bgt 29$ 30$ #3 -> vai pro pc = 11
        rom[9] = 32'b00000001000111100111001101100011;  // bgtu 28$ 17$ #3  -> vai pro pc = 12
        rom[10] = 32'b11111111111111110001111011100011;  // bne 30$ 31$ #-2 -> vai pro pc = 8
        rom[11] = 32'b11111110111100000100111011100011;  // blt 0$ $15 #-2  -> vai pro pc = 9
        rom[12] = 32'b00000001111001101110001101100011;  // bltu 13$ 30$ #2 -> vai pro pc = 15
        rom[13] = 32'b00000000000000000000110100010111; // auipc $26 #0 -> reg[26] = pc = 13 
        rom[14] = 32'b00000000010111010000110011100111; // jalr $25 $26 #5 -> reg[25] = pc+1 = 15 e pc = reg[26] + imm = 18
        rom[15] = 32'b11111111110111111111110111101111; // jal $27 #-2 -> salva pc+1 no reg[27] e pula pro pc = 13
        rom[16] = 32'b0;    // Pulado
        rom[17] = 32'b0;    // Pulado
        rom[18] = 32'b01101011111111110101100111100011;     // bgt 30$ 31$ #25 -> false branch
        rom[19] = 32'b01010100000000001110010101100011;     // bltu 1$ $0 #-8  -> false branch
        rom[20] = 32'b11001101101001101001101101100011;     // bne 13$ $26 #42  -> false branch
        for (i=21; i<64; i=i+1)
            rom[i] = 32'b0;
    end  
    
    /* So devolve uma instrucao se o endereco estiver dentro do tamanho da memoria */
    assign instrucao = (pc[63:0] < 64 )? rom[pc]: 31'd0;

endmodule