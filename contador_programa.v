module contador_programa (
    input clock,
    input reset,
    input branch,   // sinal que e operacao de branch
    input signed [63:0] imm,
    output [63:0] endereco
);
    /* Controla o contador de programa (PC) */
    // Adiciona instruções de salto

    wire [63:0] prox_pc;    /* Armazena o o proximo endereco do PC (real) */
    reg [63:0] pc;          /* Valor atual do PC */
    wire [63:0] pc2;          /* Valor atual do PC */

    initial begin
        pc <= 64'b0;
    end

    always @(posedge reset) begin
        pc <= 64'b0;
    end

    always @(negedge clock) begin    
        pc <= prox_pc;
    end

    /* Valor padrao de incremento do PC */
    assign pc2 = (branch)? pc + imm: pc + 64'b1;
    assign prox_pc = pc2;

    assign endereco = pc;
    
endmodule