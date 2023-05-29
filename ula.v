// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// ULA em complemento de 2
module ula #(
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
    parameter SUB = 4'b0000,
    parameter BITS = 63) (
    input signed [BITS:0] a, //Entradas em complemento de 2
    input signed [BITS:0] b,
    input [3:0] op,
    input sign,
    output v,
    output reg [BITS:0] result
);

reg overflow;

wire [BITS:0] operando1;
wire [BITS:0] operando2;

// para operações sem sinal
assign operando1 = a;
assign operando2 = b;

always @* begin
    case (op)
        SUB: result = a - b;
        ADD: result = a + b;
        EQU:  
            begin
                if (a == b) result = 1;
                else result = 0;    
            end 
        SLT: 
            begin
                if (sign) begin
                    if (a < b) result = 1;
                    else result = 0;
                end else begin
                    if (operando1 < operando2) result = 1;
                    else result = 0;
                end
            end
        SLL: result = a << (b & 5'b11111);
        XOR: result = a ^ b;
        OR: result = a | b;
        AND: result = a & b;
        SRL: result = a >> (b & 5'b11111);
        SRA: result = a >>> (b & 5'b11111);
        SGT:  
            begin
                if (sign) begin
                    if (a > b) result = 1;
                    else result = 0;
                end else begin
                    if (operando1 > operando2) result = 1;
                    else result = 0;
                end
            end
        NEQ:  
            begin
                if (a != b) result = 1;
                else result = 0;    
            end 
        default: result = a + b;
    endcase
end

always @* begin
    // Determina se houve overflow da add\sub (indeterminado em outras operacoes)
    if (op == 1) begin
        if (a[BITS] == b[BITS]) begin
            if (a[BITS] == 1) begin
                overflow = (result[BITS] == 1) ? 0: 1;
            end else begin
                overflow = (result[BITS] == 0) ? 0: 1;
            end
        end else begin
            overflow = 0;
        end
    end else begin
        if (a[BITS] != b[BITS]) begin
            if (b[BITS] == 1) begin
                overflow = (result[BITS] == 1) ? 1: 0;
            end else begin
                overflow = (result[BITS] == 0) ? 1: 0;
            end
        end else begin
            overflow = 0;
        end
    end
end

assign v = overflow;

endmodule
