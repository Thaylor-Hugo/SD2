module contador_programa (
    input clock,
    output [63:0] endereco
);
    /* Controla o contador de programa (PC) */

    wire [63:0] prox_pc;    /* Armazena o o proximo endereco do PC (real) */
    reg [63:0] pc;          /* Valor atual do PC */

    initial begin
        pc <= 64'b0;
    end

    always @(negedge clock) begin
        pc <= prox_pc;
    end

    always @(pc) begin
        /* Valor padrao de incremento do PC */
        prox_pc <= pc + 64'b1;
    end

    assign endereco = pc;
    
endmodule