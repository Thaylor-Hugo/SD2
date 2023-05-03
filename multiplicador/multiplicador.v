module multiplicador (
    input clk,
    input start,
    input [7:0] entryA,
    input [7:0] entryB,
    output done,
    output [15:0] result
);

// Sinais de controle
wire [1:0] op_mux1;
wire [1:0] op_mux2;
wire [2:0] op_mux3;
wire [2:0] op_mux4;
wire [2:0] op_mux5;
wire op_somador;
wire v;

// Variaveis da operacao
wire [7:0] A;
wire [7:0] B;
wire [4:0] D;
wire [4:0] E;
wire [9:0] de;
wire [15:0] a_bs;
wire [15:0] a_b;
wire [15:0] de_ab;
wire [9:0] endereco;
wire [9:0] out_rom;
wire [63:0] somador_result;
wire [15:0] operando1;
wire [15:0] operando2;

control_mult control_mult (clk, start, done, op_somador, op_mux1, op_mux2, op_mux3, op_mux4, op_mux5);
rom rom (endereco, out_rom);

mux_three_to_one mux1 (op_mux1, {1'b0, entryA[3:0], 1'b0, entryB[3:0]}, {1'b0, entryA[7:4], 1'b0, entryB[7:4]}, {D, E}, endereco);
mux_one_to_three mux2 (op_mux2, out_rom, A, B, de);
mux_five_to_one mux3 (op_mux3, {12'b0, entryA[7:4]}, {12'b0, entryB[7:4]}, {8'b0, A}, {6'b0, de}, a_bs, operando1);
mux_five_to_one mux4 (op_mux4, {12'b0, entryA[3:0]}, {12'b0, entryB[3:0]}, {8'b0, B}, a_b, {de_ab[11:0], 4'b0}, operando2);
mux_one_to_five mux5 (op_mux5, somador_result[15:0], a_b, D, E, de_ab, result);

assign a_bs = {B, A};

somador somador ({48'b0, operando1}, {48'b0, operando2}, op_somador, v, somador_result);

endmodule