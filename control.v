// Modulo de controle do processador

module control #(
    parameter BITS = 63,
    parameter R_TYPE = 7'b0110011,
    parameter ARITMETIC_I = 7'b0010011,
    parameter LOAD_TYPE = 7'b0000011,
    parameter STORE_TYPE = 7'b0100011,
    parameter SUBI = 7'b0011111,
    parameter JAL = 7'b1101111,
    parameter JALR = 7'b1100111,
    parameter BRANCH = 7'b1100011,
    parameter AUIPC = 7'b0010111,

    // Ula opcode parameters:
    parameter NEQ = 4'b1011,
    parameter SGT = 4'b1010,
    parameter SRA = 4'b1001,
    parameter SRL = 4'b1000,
    parameter AND = 4'b0111,
    parameter OR = 4'b0110,
    parameter XOR = 4'b0101,
    parameter SLL = 4'b0100,
    parameter SLT = 4'b0011,
    parameter EQU = 4'b0010,
    parameter ADD = 4'b0001,
    parameter SUB = 4'b0000
) (
    input [31:0] instrucao,

    output reg load_en,
    output reg store_en,
    output reg [3:0] op_ula,     // verificar no modulo ula
    output reg [1:0] operation_type,   // 00 se ula_out, 01 se mem_read, 10 se pc
    output reg ula_entry,        // 0 se imm_ext, 1 se rs2
    output reg branch,           // instrução e branch
    output reg auipc, 
    output reg jal, 
    output reg jalr,
    output reg sign,
    output [BITS:0] imm_ext
);

wire [6:0] opcode = instrucao[6:0];
wire [14:12] funct3 = instrucao[14:12];
wire [31:25] funct7 = instrucao[31:25];

wire [11:0] imm;
wire [19:0] imm_jump;
wire [BITS:0] imm_ext;

assign imm = (store_en)? {instrucao[31:25], instrucao[11:7]} : 
             (branch)? {instrucao[31], instrucao[7], instrucao[30:25], instrucao[11:8]} : 
             instrucao[31:20];

assign imm_jump = (auipc)? instrucao[31:12] : 
                    {instrucao[31], instrucao[19:12], instrucao[20], instrucao[30:21]};

assign imm_ext = (auipc || jal)? ((imm_jump[19])? {{44{1'b1}}, imm_jump} : {44'b0, imm_jump}) :
                 (imm[11])? {{52{1'b1}}, imm} : {52'b0, imm};

always @(*) begin
    case (opcode)
        R_TYPE: begin
            load_en = 1;
            store_en = 0;
            jal = 0;
            jalr = 0;
            auipc = 0;
            branch = 0;
            ula_entry = 1;
            operation_type = 2'b00;
            case (funct3)
                3'b000: case (funct7)
                            7'b0000000: op_ula = ADD;
                            7'b0100000: op_ula = SUB;
                        endcase
                3'b001: op_ula = SLL;
                3'b010: begin
                    op_ula = SLT;
                    sign = 1;
                end
                3'b011: begin
                    op_ula = SLT;
                    sign = 0;
                end 
                3'b100: op_ula = XOR;
                3'b101: case (funct7)
                    7'b0000000: op_ula = SRL; 
                    7'b0100000: op_ula = SRA; 
                endcase
                3'b110: op_ula = OR;
                3'b111: op_ula = AND;
            endcase
        end
        ARITMETIC_I: begin
            load_en = 1;
            store_en = 0;
            jal = 0;
            jalr = 0;
            auipc = 0;
            branch = 0;
            ula_entry = 0;
            operation_type = 2'b00;
            case (funct3)
                3'b000: op_ula = ADD;
                3'b001: op_ula = SLL;
                3'b010: begin
                    op_ula = SLT;
                    sign = 1;
                end
                3'b011: begin
                    op_ula = SLT;
                    sign = 0;
                end 
                3'b100: op_ula = XOR;
                3'b101: case (funct7)
                    7'b0000000: op_ula = SRL; 
                    7'b0100000: op_ula = SRA; 
                endcase
                3'b110: op_ula = OR;
                3'b111: op_ula = AND;
            endcase
        end 
        LOAD_TYPE: begin
            load_en = 1;
            store_en = 0;
            jal = 0;
            jalr = 0;
            auipc = 0;
            branch = 0;
            ula_entry = 0;
            operation_type = 2'b01;
            op_ula = ADD;
            sign = 1;
        end 
        STORE_TYPE: begin
            load_en = 0;
            store_en = 1;
            jal = 0;
            jalr = 0;
            auipc = 0;
            branch = 0;
            ula_entry = 0;
            operation_type = 2'b01;
            op_ula = ADD;
            sign = 1;
        end 
        SUBI: begin
            load_en = 1;
            store_en = 0;
            jal = 0;
            jalr = 0;
            auipc = 0;
            branch = 0;
            ula_entry = 0;
            operation_type = 2'b00;
            op_ula = SUB;
            sign = 1;
        end 
        JAL: begin
            load_en = 1;
            store_en = 0;
            op_ula = ADD;
            operation_type = 2'b10;
            ula_entry = 0;
            branch = 0;
            auipc = 0;
            jal = 1;
            jalr = 0;
            sign = 1;
        end
        JALR: begin
            load_en = 1;
            store_en = 0;
            op_ula = ADD;
            operation_type = 2'b10;
            ula_entry = 0;
            branch = 0;
            auipc = 0;
            jal = 0;
            jalr = 1;
            sign = 1;
        end
        BRANCH: begin
            load_en = 0;
            store_en = 0;
            operation_type = 2'b10;
            ula_entry = 1;
            branch = 1;
            auipc = 0;
            jal = 0;
            jalr = 0;
            case (funct3)
                3'b000: op_ula = EQU;
                3'b001: op_ula = NEQ;
                3'b100: begin
                    op_ula = SLT;
                    sign = 1;
                end
                3'b101: begin
                    op_ula = SGT;
                    sign = 1;
                end
                3'b110: begin
                    op_ula = SLT;
                    sign = 0;
                end
                3'b111: begin
                    op_ula = SGT;
                    sign = 0;
                end 
            endcase
        end
        AUIPC: begin
            load_en = 1;
            store_en = 0;
            op_ula = ADD;
            operation_type = 2'b10;
            ula_entry = 0;
            branch = 0;
            auipc = 1;
            jal = 0;
            jalr = 0;
            sign = 1;
        end
        default: begin
            // Apenas leitura de registradores
            load_en = 0;
            store_en = 0;
            branch = 0;
            auipc = 0;
            jal = 0;
            jalr = 0;
        end
    endcase    
end
    
endmodule
