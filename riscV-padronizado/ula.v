// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

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
