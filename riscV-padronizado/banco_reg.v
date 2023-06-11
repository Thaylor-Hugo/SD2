// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

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