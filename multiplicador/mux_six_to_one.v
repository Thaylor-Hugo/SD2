// Multiplexador de 6 entradas e 1 saida

module mux_six_to_one (
    input [2:0] op, 
    input [15:0] a,
    input [15:0] b, 
    input [15:0] c, 
    input [15:0] d, 
    input [15:0] e, 
    input [15:0] f, 
    output reg [15:0] saida
);

// OP cases:
// op = 000 -> endereco = a
// op = 001 -> endereco = b
// op = 010 -> endereco = c
// op = 011 -> endereco = d
// op = 100 -> endereco = e
// op = 101 -> endereco = f
// op = 11x -> endereco = f

always @(*) begin
    case (op)
        3'b000: saida = a;
        3'b001: saida = b;
        3'b010: saida = c;
        3'b011: saida = d;
        3'b100: saida = e;
        3'b101: saida = f;
        default: saida = f;
    endcase
end
    
endmodule