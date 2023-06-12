module memoria_instrucao (
    input [5:0] i_mem_addr,
    output [31:0] i_mem_data
);
    /* Memoria de instrucao que busca testar uma de cada instrucoes de processador */

    reg [31:0] rom [63:0];  /* 64 espaços de memoria */
    integer i;

    initial begin  
        rom[0] = 32'b00000000000000011010000010000011;  // load $1, $3, #0;
        rom[1] = 32'b00000000000000100010000100000011;  // load $2, $4, #0;
        rom[2] = 32'b00000000001000001000111001100011; // beq $1, $2, #28;
        rom[3] = 32'b00000000001000001011111110110011; // sltu $31, $1, $2;
        rom[4] = 32'b00000000000011111000011001100011; // beq $31, $0, #12;
        rom[5] = 32'b01000000000100010000000100110011; // sub $2, $2, $1;
        rom[6] = 32'b00000000100000000000111101101111;    // jal #8;
        rom[7] = 32'b01000000001000001000000010110011; // sub $1, $1, $2;
        rom[8] = 32'b11111110100111111111111101101111;    // jal #-24;
        rom[9] = 32'b00000000000100000010001010100011; // store $1, $0, #5;
        rom[10] = 32'b00000000000000000000000001100011;// beq $0, $0, #0;
        for (i=11; i<64; i=i+1)
            rom[i] = 32'b0;
    end  
    
    /* So devolve uma instrucao se o endereco estiver dentro do tamanho da memoria */
    assign i_mem_data = (i_mem_addr[5:2] < 64 )? rom[i_mem_addr[5:2]]: 31'd0;

endmodule