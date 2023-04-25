// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Somador/subtrador em complemento de 2 com sinal de overflow
module somador #(
    parameter ADD = 1,
    parameter SUB = 0,
    parameter BITS = 63) (
    input signed [BITS:0] a, //Entradas em complemento de 2
    input signed [BITS:0] b,
    input op, // Se 1 realiza soma, se 0 realiza subtracao
    output v,
    output [BITS:0] result
);

reg overflow;

assign result = (op == 1) ? a + b: a - b;

always @* begin
    // Determina se houve overflow
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
