module memoria_instrucao (
    input [5:0] i_mem_addr,
    output [31:0] i_mem_data
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
        rom[5] = 32'b00000010101000011010111000010011; // slti 28$ 3$ #42   ->  reg[28] = 1        // nao ha subi on risc v, entao usando combinacao de opcode que nao e usada por outra instrucao
        rom[6] = 32'b00000011110111110010010000100011; // store reg[29] in mem[40+reg[30]] -> mem[29] = 86
        rom[7] = 32'b00000000011100001000011001100011;  // beq 1$ 7$ #12 -> vai pro pc = 10
        rom[8] = 32'b0;
        rom[9] = 32'b00000000011100001000101001100011; // beq 1$ 7$ #20 -> vai pro pc = 14
        rom[10] = 32'b11111111110111111111110111101111; // jal $27 #-4 -> salva pc+1 no reg[27] e pula pro pc = 9
        for (i=11; i<64; i=i+1)
            rom[i] = 32'b0;
    end  
    
    /* So devolve uma instrucao se o endereco estiver dentro do tamanho da memoria */
    assign i_mem_data = (i_mem_addr[5:2] < 64 )? rom[i_mem_addr[5:2]]: 31'd0;

endmodule