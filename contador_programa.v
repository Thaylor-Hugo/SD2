module contador_programa (
    input clock,
    input reset,
    input branch,   // sinal que e operacao de branch
    input auipc,    // sinal que e operacao de auipc
    input jal,      // sinal que e operacao de jal
    input jalr,     // sinal que e operacao de jalr
    input [63:0] target_pc, // valor do registrador pra instrução jalr
    input signed [63:0] imm,
    output [63:0] endereco,
    output [63:0] next_pc
);
    /* Controla o contador de programa (PC) */
    // Adiciona instruções de salto

    wire [63:0] prox_pc;    /* Armazena o o proximo endereco do PC (real) */
    wire [63:0] pc2;        /* Valor do pc do PC */
    wire [63:0] stored_pc;
    reg [63:0] pc;          /* Saida do PC (proxima instrução) */

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
    assign stored_pc = (auipc)? pc + {imm[51:0], 12'b0}: pc + 1'b1;

    assign pc2 = (branch)? pc + imm: 
                     (jalr)? target_pc + imm: 
                     (jal)? pc + imm: 
                     pc + 1'b1;
;
    assign prox_pc = pc2;
    assign endereco = pc;
    assign next_pc = stored_pc;
    
endmodule