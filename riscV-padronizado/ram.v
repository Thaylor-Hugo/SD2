// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

// Modulo de memoria de dados
module ram #(
    parameter d_addr_bits = 6
) (
    input clk, d_mem_we,
    input [d_addr_bits-1:0] d_mem_addr, 
    inout [63:0] d_mem_data
);  
    reg [63:0] ram[63:0];
    integer i;  
    initial begin
        for(i=0; i<64; i=i+1)  
            ram[i] <= i;
    end  
    always @(posedge clk) begin  
        if (d_mem_we) ram[d_mem_addr] <= d_mem_data;
    end  
    
    // Retorna valor da memoria apenas se d_mem_addr for menor ou igual que a ultima celula
    assign d_mem_data = (d_mem_we)? 64'hz : ram[d_mem_addr];
endmodule
