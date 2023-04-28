// Multiplexador de 3 entradas e 1 saida

module mux_three_to_one (
    input [1:0] op, 
    input [9:0] a,
    input [9:0] b, 
    input [9:0] c, 
    output [9:0] saida
);

// OP cases:
// op = 00 -> endereco = a
// op = 01 -> endereco = b
// op = 10 -> endereco = c
// op = 11 -> endereco = c

assign saida = (op == 2'b00) ? a : ((op == 2'b01)? b : c);
    
endmodule