// modulo de mux com duas entradas e uma saida

module mux_two_to_one #(
    parameter BITS = 26
) (
    input op,   // 1 para saida a, 0 para saida b
    input [BITS:0] a,
    input [BITS:0] b,
    output [BITS:0] out
);

assign out = (op)? a: b;
    
endmodule