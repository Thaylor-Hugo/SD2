// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Modulo que realiza operacoes de load e store, add e sub
module datapath #(
    parameter BITS = 63
) (
    input clk,
    input enable,
    input [4:0] ra, 
    input [4:0] rb,
    input signed [BITS:0] dataIn,
    input load_store,       //1 se for load ou tipo R, 0 se for store
    input op_ula,           //1 se for soma, 0 se for sub
    input operation_type,   //1 se for tipo R, 0 se for memory type
    input ula_entry,        //1 se for Reg, 0 se for imm
    input [4:0] rw,

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

assign load_en = (enable)? load_store: 0;
assign store_en = (enable)? ~load_store: 0;

// Decide entrada do banco de registradores
mux_two_to_one mux_banco_reg(operation_type, ula_out, mem_read, din_reg);
// Decide entrada da ULA
mux_two_to_one mux_ula(ula_entry, valor_regA, dataIn, din_ula);

somador somador(dataOutB, din_ula, op_ula, v, ula_out);
banco_reg banco_reg (clk, load_en, rw, ra, rb, din_reg, valor_regA, valor_regB);
ram ram (clk, store_en, ula_out, valor_regA, mem_read);

assign dataOutA = valor_regA;
assign dataOutB = valor_regB;
    
endmodule
