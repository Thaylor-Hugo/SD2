module memoria_instrucao (
    input [63:0] pc,
    output [31:0] instrucao
);
    /* Memoria de instrucao que busca testar todas as instrucoes de processador */

    reg [31:0] rom [63:0];  /* 64 espaços de memoria */
    integer i;

    initial begin  
        rom[0] = 32'b;
        rom[1] = 32'b;
        rom[2] = 32'b;
        rom[3] = 32'b;
        rom[4] = 32'b;
        rom[5] = 32'b;
        for (i=6; i<64; i=i+1)
            rom[i] = 32'b0;
    end  
    
    /* So devolve uma instrucao se o endereco estiver dentro do tamanho da memoria */
    assign instrucao = (pc[31:0] < 64 )? rom[pc]: 31'd0;

endmodule