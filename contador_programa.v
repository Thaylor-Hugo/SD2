module contador_programa (
    input clock,
    input reset,
    output [63:0] endereco
);
    /* Controla o contador de programa (PC) */

    wire [63:0] prox_pc;    /* Armazena o o proximo endereco do PC (real) */
    reg [63:0] pc;          /* Valor atual do PC */

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
    assign prox_pc = pc + 64'b1;

    assign endereco = pc;
    
endmodule