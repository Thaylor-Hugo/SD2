// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Modulo de um registrador unico
module registrador #(
    parameter BITS = 63
    )(
    input clk,
    input load,
    input [BITS:0] dataIn,
    output [BITS:0] dataOut
);

reg [BITS:0] data;

initial begin
    data = 0;
end

always @(posedge clk) begin
    if (load == 1) begin
        data <= dataIn;
    end
end

assign dataOut = data;

endmodule