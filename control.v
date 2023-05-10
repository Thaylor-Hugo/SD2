// Modulo de controle do processador

module control #(
    BITS = 63,
    R_TYPE = 7'b0110011,
    ARITMETIC_I = 7'b0010011,
    LOAD_TYPE = 7'b0000011,
    STORE_TYPE = 7'b0100011
    SUBI = 7'b0011111;
) (
    input [31:0] instrucao,
    output reg load_en, 
    output reg store_en,
    output reg [1:0] op_ula,    // verificar no modulo ula
    output reg operation_type,  // 0 se mem, 1 se outra
    output reg ula_entry        // 0 se imm, 1 se rs2
);

wire [6:0] opcode;
wire [14:12] funct3;
wire [31:25] funct7;

case (opcode)
    R_TYPE: begin
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 1;
        if (funct3 == 3'b0) begin
            if (funct7 == 7'b0) op_ula = 2'b01;
            else op_ula = 2'b0;
        end
        else if (funct3 == 3'b010) begin
            op_ula = 2'b11;
        end
    end
    ARITMETIC_I: begin
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 0;
        if (funct3 == 3'b0)
            op_ula = 2'b01;
        else
            op_ula = 2'b11;
    end 
    LOAD_TYPE: begin
        load_en = 1;
        store_en = 0;
        operation_type = 0;
        ula_entry = 0;
        op_ula = 2'b01;
    end 
    STORE_TYPE: begin
        load_en = 0;
        store_en = 1;
        operation_type = 0;
        ula_entry = 0;
        op_ula = 2'b01;
    end 
    SUBI: begin
        load_en = 1;
        store_en = 0;
        operation_type = 1;
        ula_entry = 0;
        op_ula = 2'b00;
    end 
    default: begin
        // Apenas leitura de registradores
        load_en = 0;
        store_en = 0;
    end
endcase
    
endmodule
