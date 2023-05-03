module contador_programa (
    input clock, reset, branch, jump, jr, 
    input [15:0] data_reg_jump, 
    input [12:0] target_jump, 
    input [15:0] immediato_extended,
    output [15:0] endereco
);
    /* Controla o contador de programa (PC) */

    wire [15:0] prox_pc;    /* Armazena o o proximo endereco do PC (real) */
    reg [15:0] pc2;         /* E altera conforme a instrucao para determinar o prox_pc */
    reg [15:0] pc;          /* Valor atual do PC */

    always @(negedge clock or posedge reset) begin
        if (reset)
            pc <= 16'b0;
        else begin
            pc <= prox_pc;
        end
    end

    always @(pc) begin
        /* Valor padrao de incremento do PC */
        pc2 <= pc + 16'b10;
    end

    always @(branch or jump or jr) begin
        /* Altera o valor do PC para instrucoes especificas */
        if (branch) 
            pc2 <= pc2 + {immediato_extended[14:0], 1'b0};
        else if (jump)
            pc2 <= {pc2[15:14], {target_jump, 1'b0}};
        else if (jr)
            pc2 <= data_reg_jump;
    end

    assign prox_pc = pc2;
    assign endereco = pc;
    
endmodule