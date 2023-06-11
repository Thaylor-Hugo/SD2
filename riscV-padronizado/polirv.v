module polirv 
    #(
        parameter i_addr_bits = 6,
        parameter d_addr_bits = 6
    ) (
        input clk, rst_n,        // clock borda subida, reset assíncrono ativo baixo
        output [i_addr_bits-1:0] i_mem_addr,
        input  [31:0]            i_mem_data,
        output                   d_mem_we,
        output [d_addr_bits-1:0] d_mem_addr,
        inout  [63:0]            d_mem_data
    );

    wire [6:0] opcode;              // OpCode direto do IR no FD
    wire rf_we;                     // Habilita escrita na memória de dados e no banco de registradores
    wire [3:0] alu_flags;           // Flags da ULA
    wire [3:0] alu_cmd;             // Operação da ULA
    wire alu_src, pc_src, rf_src; 

    uc uc (clk, rst_n, opcode, d_mem_we, rf_we, alu_flags, alu_cmd, alu_src, pc_src, rf_src);
    fd fd (clk, rst_n, opcode, d_mem_we, rf_we, alu_cmd, alu_flags, alu_src, pc_src, rf_src, i_mem_addr, i_mem_data, d_mem_addr, d_mem_data);    

endmodule