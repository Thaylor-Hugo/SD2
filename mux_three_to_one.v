// modulo de mux com tres entradas e uma saida

module mux_three_to_one #(
    parameter BITS = 63
) (
    input [1:0] op,
    input [BITS:0] a,
    input [BITS:0] b,
    input [BITS:0] c,
    output [BITS:0] out
);

// OP cases:
// op = 00 -> endereco = a
// op = 01 -> endereco = b
// op = 10 -> endereco = c
// op = 11 -> endereco = c

assign out = (op == 2'b00)? a: (op == 2'b01)? b: c;
    
endmodule