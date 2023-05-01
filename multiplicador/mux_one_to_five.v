// Multiplexador de 1 entrada e 5 saidas

module mux_one_to_five (
    input [2:0] op, 
    input [15:0] entrada,
    output [15:0] a,
    output [15:0] b, 
    output [15:0] c,
    output [15:0] d,
    output [15:0] e
);

// OP cases:
// op = 000 -> a = entrada
// op = 001 -> b = entrada
// op = 010 -> c = entrada
// op = 011 -> d = entrada
// op = 100 -> e = entrada

assign a = (op == 3'b000) ? entrada : a;
assign b = (op == 3'b001) ? entrada : b;
assign c = (op == 3'b010) ? entrada : c;
assign d = (op == 3'b011) ? entrada : d;
assign e = (op == 3'b100) ? entrada : e;
    
endmodule