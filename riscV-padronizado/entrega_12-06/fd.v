// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 12/06

// fluxo de dados
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

// Banco de 32 registradores de 64bits
module banco_reg (
    input clk, rf_we,
    input [4:0] endereco_regd, endereco_reg1, endereco_reg2,
    input [63:0] dado_escrita,
    output [63:0] valor_reg1, valor_reg2
);

    integer i;
    reg [63:0] registradores [31:0]; 

    initial begin
        for (i=0; i<32; i=i+1) begin
            registradores[i] <= i;
        end
    end

    always @(posedge clk) begin
        if (rf_we) registradores[endereco_regd] = dado_escrita;
    end
    
    /* registradores[0] reservado -> sempre retorna 0 */

    assign valor_reg1 = (endereco_reg1 == 0)? 64'b0 : registradores[endereco_reg1];
    assign valor_reg2 = (endereco_reg2 == 0)? 64'b0 : registradores[endereco_reg2];
    
endmodule

// ULA em complemento de 2
module ula (
    input signed [63:0] a, //Entradas em complemento de 2
    input signed [63:0] b,
    input [3:0] alu_cmd,
    input [2:0] funct3,
    input [6:0] funct7,
    output [3:0] alu_flags,
    output reg [63:0] result
);

reg overflow;

// para operações sem sinal
wire [63:0] operando1 = a;
wire [63:0] operando2 = b;

always @* begin
    case (alu_cmd)
        4'b0000: 
            begin
                case (funct3)
                    3'b000: 
                        case (funct7)
                            7'b0000000: result = a + b;
                            7'b0100000: result = a - b;
                        endcase
                    3'b001: result = a << (b & 5'b11111);
                    3'b010: 
                        begin
                            if (a < b) result = 1;
                            else result = 0;
                        end
                    3'b011: 
                        begin
                            if (operando1 < operando2) result = 1;
                            else result = 0;
                        end 
                    3'b100: result = a ^ b;
                    3'b101: 
                        case (funct7)
                            7'b0000000: result = a >> (b & 5'b11111);
                            7'b0100000: result = a >>> (b & 5'b11111);
                        endcase
                    3'b110: result = a | b;
                    3'b111: result = a & b; 
                    default: result = a + b;
                endcase
            end
        4'b0001:
            begin
                case (funct3)
                    3'b000: result = a + b;
                    3'b001: result = a << (b & 5'b11111);
                    3'b010: 
                        begin
                            if (a < b) result = 1;
                            else result = 0;
                        end
                    3'b011: 
                        begin
                            if (operando1 < operando2) result = 1;
                            else result = 0;
                        end 
                    3'b100: result = a ^ b;
                    3'b101: 
                        case (funct7)
                            7'b0000000: result = a >> (b & 5'b11111);
                            7'b0100000: result = a >>> (b & 5'b11111);
                        endcase
                    3'b110: result = a | b;
                    3'b111: result = a & b; 
                    default: result = a + b;
                endcase
            end
        4'b0010: result = a + b;
        4'b0011: result = a - b;    // BEQ
        4'b0100: result = a + b;
        4'b0101: result = a + b;
        default: result = a + b;
    endcase
end

always @* begin
    // Determina se houve overflow da add\sub (indeterminado em outras operacoes)
    if (funct3 == 3'b0 && funct7 == 7'b0) begin
        if (a[63] == b[63]) begin
            if (a[63] == 1) begin
                overflow = (result[63] == 1) ? 0: 1;
            end else begin
                overflow = (result[63] == 0) ? 0: 1;
            end
        end else begin
            overflow = 0;
        end
    end else begin
        if (a[63] != b[63]) begin
            if (b[63] == 1) begin
                overflow = (result[63] == 1) ? 1: 0;
            end else begin
                overflow = (result[63] == 0) ? 1: 0;
            end
        end else begin
            overflow = 0;
        end
    end
end

assign alu_flags[0] = (result == 0)? 1 : 0;     // zeroFlag
assign alu_flags[1] = result[63];               // mostSignificantBit
assign alu_flags[2] = overflow;                 // overflow
assign alu_flags[3] = 1;                        // const

endmodule

module contador_programa #(  
    // Tamanho em 63 dos barramentos
    parameter i_addr_63 = 6
) (
    input clock,
    input reset,
    input pc_src,      // sinal que e operacao de jal/branch
    input signed [63:0] imm,
    output [i_addr_63-1:0] i_mem_addr
);
    /* Controla o contador de programa (PC) */

    wire [63:0] prox_pc;    /* Armazena o proximo endereco do PC */
    reg [63:0] pc;          /* Saida do PC */

    initial begin
        pc <= 64'b0;
    end

    always @(negedge clock or negedge reset) begin    
        if (~reset) begin
            pc <= 64'b0;        
        end else begin
            pc <= prox_pc;
        end
    end

    assign prox_pc = (pc_src)? pc + {imm[62:0], 1'b0} : pc + 64'd4; // Incremento do PC
    assign i_mem_addr = pc;

endmodule