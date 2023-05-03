// Multiplexador de 5 entradas e 1 saida

module mux_five_to_one (
    input [2:0] op, 
    input [15:0] a,
    input [15:0] b, 
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    output reg [15:0] saida
);

// OP cases:
// op = 000 -> saida = a
// op = 001 -> saida = b
// op = 010 -> saida = c
// op = 011 -> saida = d
// op = 1xx -> saida = e

always @(*) begin
    case (op)
        3'b000: saida = a;
        3'b001: saida = b;
        3'b010: saida = c;
        3'b011: saida = d;
        3'b100: saida = e;
        default: saida = e;
    endcase
end

endmodule