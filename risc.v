module risc #(
    parameter BITS = 63
) (
    input clk,
    input reset,
    output [BITS:0] program_counter,
    output [31:0] instru
);

    wire load_en;
    wire store_en;
    wire [3:0] op_ula;
    wire [1:0] operation_type;
    wire ula_entry;
    wire branch;
    wire auipc;
    wire jal;
    wire jalr;
    wire sign;
    wire [BITS:0] imm_ext;

    wire [BITS:0] program_counter;
    wire [31:0] instru;

datapath datapath(clk, reset, load_en, store_en, op_ula, operation_type, ula_entry, branch, auipc, jal, jalr, sign, imm_ext, program_counter, instru);
control control(instru, load_en, store_en, op_ula, operation_type, ula_entry, branch, auipc, jal, jalr, sign, imm_ext);
    
endmodule