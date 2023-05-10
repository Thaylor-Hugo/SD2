// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// ULA em complemento de 2
module ula #(
    parameter SLT = 11,
    parameter EQU = 10,
    parameter ADD = 01,
    parameter SUB = 00,
    parameter BITS = 63) (
    input signed [BITS:0] a, //Entradas em complemento de 2
    input signed [BITS:0] b,
    input [1:0] op,
    output v,
    output reg [BITS:0] result
);

reg overflow;

always @* begin
    case (op)
        SUB: result = a - b;
        ADD: result = a + b;
        EQU:  
            begin
                if (a == b) resultado = 1;
                else resultado = 0;    
            end 
        SLT: 
            begin
                if (a < b) resultado = 1;
                else resultado = 0;
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
