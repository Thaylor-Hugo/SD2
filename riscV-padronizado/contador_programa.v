module contador_programa #(  
    // Tamanho em 63 dos barramentos
    parameter i_addr_63 = 6
) (
    input clock,
    input reset,
    input pc_src,      // sinal que e operacao de jal/branch
    input signed [63:0] imm,
    output [i_addr_63-1:0] i_mem_addr
);
    /* Controla o contador de programa (PC) */

    wire [63:0] prox_pc;    /* Armazena o proximo endereco do PC */
    reg [63:0] pc;          /* Saida do PC */

    initial begin
        pc <= 64'b0;
    end

    always @(posedge reset) begin
        pc <= 64'b0;
    end

    always @(negedge clock) begin    
        pc <= prox_pc;
    end

    assign prox_pc = (pc_src)? pc + {imm[62:0], 1'b0} : pc + 64'd4; // Incremento do PC
    assign i_mem_addr = pc;

endmodule