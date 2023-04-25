// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Modulo de memoria de dados
module ram #(
    parameter BITS = 63,
    parameter MEM_SIZE = 31
) (
    input clock, permisao_escrita,
    input [BITS:0] endereco, dado_escrita,
    output [BITS:0] dado_leitura
);  

    // Modulo de 1MB de Ram
    reg [BITS:0] ram[MEM_SIZE:0];
    integer i;  
    initial begin
        for(i=0;i<=MEM_SIZE;i=i+1)  
            ram[i] <= i;
    end  
    always @(posedge clock) begin  
        if (permisao_escrita)  
            ram[endereco] <= dado_escrita;
    end  
    
    // Retorna valor da memoria apenas se endereco for menor ou igual que a ultima celula
    assign dado_leitura = (endereco<=MEM_SIZE)? ram[endereco] : 64'd0;
endmodule
