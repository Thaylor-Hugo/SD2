// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// data: 03/05/2023

// Modulo que realiza operacoes de load e store, add e sub
// Foi adicionado contador programa e memoria de instrução, mas não houve tempo durante a aula para preencher a memoria de instrução,
// logo ainda não há um testbench funcional para essa nova versão
module datapath #(
    parameter BITS = 63
) (
    input clk,
    input enable,
    input signed [BITS:0] dataIn,
    input load_store,       //1 se for load ou tipo R, 0 se for store
    input op_ula,           //1 se for soma, 0 se for sub
    input operation_type,   //1 se for tipo R, 0 se for memory type
    input ula_entry,        //1 se for Reg, 0 se for imm

    output signed [BITS:0] dataOutA, 
    output signed [BITS:0] dataOutB 
);

wire signed [BITS:0] valor_regA;
wire signed [BITS:0] valor_regB;
wire v; // overflow da soma
wire [BITS:0] mem_read;
wire [BITS:0] ula_out;
wire load_en;
wire store_en;
wire signed [BITS:0] din_reg;
wire signed [BITS:0] din_ula;

wire [63:0] pc;
wire [31:0] instrucao;
reg [31:0] ri; // registrador que salva instrução

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [63:0] imm;

always @(instrucao) begin
    ri = instrucao;
    if (instrucao[31] == 0) begin
        if (store_en) begin
            imm = {52'hFFFFFFFFFFFFF,instrucao[31:20]};
        end else begin
            imm = {52'h0,instrucao[31:20]};
        end
    end else begin
        if (store_en) begin
            imm = {52'hFFFFFFFFFFFFF, instrucao[31:25], rd};
        end else begin
            imm = {52'h0, instrucao[31:25], rd};
        end
    end
end

assign load_en = (enable)? load_store: 0;
assign store_en = (enable)? ~load_store: 0;

contador_programa contador_programa (clk, pc);

memoria_instrucao memoria_instrucao (pc, instrucao);

assign rs1 = instrucao[19:15];
assign rs2 = instrucao[24:20];
assign rd = instrucao[11:7];

// Decide entrada do banco de registradores
mux_two_to_one mux_banco_reg(operation_type, ula_out, mem_read, din_reg);
// Decide entrada da ULA
mux_two_to_one mux_ula(ula_entry, valor_regA, imm, din_ula);

somador somador(dataOutB, din_ula, op_ula, v, ula_out);
banco_reg banco_reg (clk, load_en, rd, rs1, rs2, din_reg, valor_regA, valor_regB);
ram ram (clk, store_en, ula_out, valor_regA, mem_read);

assign dataOutA = valor_regA;
assign dataOutB = valor_regB;
    
endmodule
