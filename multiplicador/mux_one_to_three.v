// Multiplexador de 1 entrada e 3 saidas

module mux_one_to_three (
    input [1:0] op, 
    input [9:0] entrada,
    output [9:0] a,
    output [9:0] b, 
    output [9:0] c
);

// OP cases:
// op = 00 -> a = entrada
// op = 01 -> b = entrada
// op = 10 -> c = entrada
// op = 11 -> nada acontece

assign a = (op == 2'b00) ? entrada : a;
assign b = (op == 2'b01) ? entrada : b;
assign c = (op == 2'b10) ? entrada : c;
    
endmodule