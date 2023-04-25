// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Modulo que realiza operacoes de load e store
module rf #(
    parameter BITS = 63
) (
    input clk,
    input enable,
    input [4:0] ra, 
    input [4:0] rb,
    input [BITS:0] dataIn,
    input load_store, //1 se for load, 0 se for store
    input [4:0] rw,

    output [BITS:0] dataOutA, 
    output [BITS:0] dataOutB 
);

wire [BITS:0] valor_regA;
wire [BITS:0] valor_regB;
wire v; // overflow da soma
wire [BITS:0] mem_read;
wire [BITS:0] endereco;
reg load_en;
reg store_en;

always @* begin
    if (enable) begin
        load_en = load_store;
        store_en = ~load_store;
    end else begin
        load_en = 0;
        store_en = 0;
    end
end

somador somador(dataIn, dataOutB, 1'b1, v, endereco);
banco_reg banco_reg (clk, load_en, rw, ra, rb, mem_read, valor_regA, valor_regB);
ram ram (clk, store_en, endereco, valor_regA, mem_read);

assign dataOutA = valor_regA;
assign dataOutB = valor_regB;
    
endmodule
