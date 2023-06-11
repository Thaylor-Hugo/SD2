module fd 
    #(  // Tamanho em 63 dos barramentos
        parameter i_addr_63 = 6,
        parameter d_addr_63 = 6
    )(
        input  clk, rst_n,                   // clock borda subida, reset assíncrono ativo baixo
        output [6:0] opcode,                    
        input  d_mem_we, rf_we,              // Habilita escrita na memória de dados e no banco de registradores
        input  [3:0] alu_cmd,                // ver abaixo
        output [3:0] alu_flags,
        input  alu_src,                      // 0: rf, 1: imm
               pc_src,                       // 0: +4, 1: +imm
               rf_src,                       // 0: alu, 1:d_mem
        output [i_addr_63-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output [d_addr_63-1:0] d_mem_addr,
        inout  [63:0]            d_mem_data

    );
    // AluCmd     AluFlags
    // 0000: R    0: zero
    // 0001: I    1: MSB 
    // 0010: S    2: overflow
    // 0011: SB
    // 0100: U
    // 0101: UJ

// Immediate assingment
wire [11:0] imm = (d_mem_we)? {i_mem_data[31:25], i_mem_data[11:7]} : // store imm
                  (opcode == 7'b1100011)? {i_mem_data[31], i_mem_data[7], i_mem_data[30:25], i_mem_data[11:8]} : // branch imm
                  i_mem_data[31:20];    // regular imm
wire [19:0] imm_half_ext = {{8{imm[11]}}, imm};   // pra igualar com tamanho do imm_jump
wire [19:0] imm_jump = {i_mem_data[31], i_mem_data[19:12], i_mem_data[20], i_mem_data[30:21]};
wire [63:0] imm_ext = (alu_cmd == 4'b0101)? {{44{i_mem_data[31]}}, imm_jump}: {{44{i_mem_data[31]}}, imm_half_ext};

// Register File Module Wires
wire [4:0] rs1 = i_mem_data[19:15];
wire [4:0] rs2 = i_mem_data[24:20];
wire [4:0] rd = i_mem_data[11:7];
wire signed [63:0] rf_din = (rf_src)? d_mem_data: ula_out;
wire signed [63:0] valor_reg1;
wire signed [63:0] valor_reg2;

banco_reg banco_reg(clk, rf_we, rd, rs1, rs2, rf_din, valor_reg1, valor_reg2);

// Alu Module Wires
wire [63:0] ula_out;
wire signed [63:0] ula_din = (alu_src)? imm_ext: valor_reg2;
wire [2:0] funct3 = i_mem_data[14:12];
wire [6:0] funct7 = i_mem_data[31:25];

ula ula(valor_reg1, ula_din, alu_cmd, funct3, funct7, alu_flags, ula_out);

contador_programa contador_programa(clk, rst_n, pc_src, imm_ext, i_mem_addr);
assign opcode = i_mem_data[6:0];
assign d_mem_addr = ula_out;
assign d_mem_data = (d_mem_we)? valor_reg2 : 64'hz;

endmodule