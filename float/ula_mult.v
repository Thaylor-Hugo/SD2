// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// ULA em complemento de 2
module ula_mult (
    input clk,
    input start,
    input [26:0] a,
    input [26:0] b,
    input [1:0] cmd,              // 10 e sub, 1 se soma, 0 se mult
    output done,
    output carry,
    output [26:0] result
);

reg [26:0] multiplicacao;
reg [26:0] regA, regB;
reg [26:0] menor;
wire [26:0] maior;

always @(posedge start) begin
    regA <= a;
    regB <= b;
    if (a < b) begin
        menor <= a;
    end else menor <= b;
    multiplicacao <= 0;
end

assign maior = (regA > regB)? regA : regB;

always @(multiplicacao) begin
    if (menor > 0) begin
        multiplicacao <= multiplicacao + maior;
        menor = menor - 1'b1;
    end
end

assign done = (menor == 0)? 1'b1 : 1'b0;

wire [26:0] sum;
wire [26:0] sub;

assign {carry, sum} = a + b;
assign sub = a - b;

assign result = (cmd == 2'b10)? sub: (cmd == 2'b01)? sum : multiplicacao;

endmodule
