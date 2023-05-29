// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// data: 09/05/2023

// Modulo que realiza operacoes de load e store, add, sub, addi, subi, slt, equ
// Foi adicionado contador programa e memoria de instrução

module datapath #(
    parameter BITS = 63
) (
    input clk,
    input reset,

    input load_en,
    input store_en,
    input [3:0] op_ula,     // verificar no modulo ula
    input [1:0] operation_type,   // 00 se ula_out, 01 se mem_read, 10 se pc
    input ula_entry,        // 0 se imm_ext, 1 se rs2
    input branch,           // instrução e branch
    input auipc, 
    input jal, 
    input jalr,
    input sign,             // se instruções tem sinal ou nao
    input [BITS:0] imm_ext,

    output [BITS:0] program_counter,
    output [31:0] instru
);

// Sinais de controle
wire v; // overflow da soma

// Operadores das instruções
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;

banco_reg banco_reg (clk, load_en, rd, rs1, rs2, din_reg, valor_regA, valor_regB);

assign rs1 = instrucao[19:15];
assign rs2 = instrucao[24:20];
assign rd = instrucao[11:7];

// Contador de programa e instrução
wire [BITS:0] pc;
wire [BITS:0] stored_pc;
wire [31:0] instrucao;
reg [31:0] ri; // registrador que salva instrução

wire branch_cond;

assign branch_cond = (branch)? ula_out[0] : 0;

always @(instrucao) begin
    ri = instrucao;
end

contador_programa contador_programa (clk, reset, branch_cond, auipc, jal, jalr, valor_regA, imm_ext, pc, stored_pc);
memoria_instrucao memoria_instrucao (pc, instrucao);

assign program_counter = pc;    // output

// Variaveis de auxilio
wire signed [BITS:0] valor_regA;
wire signed [BITS:0] valor_regB;
wire [BITS:0] mem_read;
wire [BITS:0] ula_out;
wire signed [BITS:0] din_reg;
wire signed [BITS:0] din_ula2;

// Decide entrada do banco de registradores
mux_three_to_one mux_banco_reg(operation_type, ula_out, mem_read, stored_pc, din_reg);

// Decide entrada da ULA
mux_two_to_one mux_ula2(ula_entry, valor_regB, imm_ext, din_ula2);

ula ula(valor_regA, din_ula2, op_ula, sign, v, ula_out);
ram ram (clk, store_en, ula_out, valor_regB, mem_read);

assign instru = instrucao;
    
endmodule
