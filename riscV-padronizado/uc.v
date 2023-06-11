module uc (
    input clk, rst_n,                       // clock borda subida, reset assíncrono ativo baixo
    input [6:0] opcode,                     // OpCode direto do IR no FD
    output d_mem_we, rf_we,                 // Habilita escrita na memória de dados e no banco de registradores
    input  [3:0] alu_flags,                 // Flags da ULA
    output [3:0] alu_cmd,                   // Operação da ULA
    output alu_src, pc_src, rf_src          // Seletor dos MUXes
); 

// AluCmd  
// 0000: R
// 0001: I
// 0010: S    
// 0011: SB
// 0100: U
// 0101: UJ

assign d_mem_we = (opcode == 7'b0100011)? 1 : 0;
assign rf_we = (opcode == 7'b0110011 || opcode == 7'b0010011 || opcode == 7'b0000011 || opcode == 7'b0011111 || opcode == 7'b1101111 || opcode == 7'b1100111 || opcode == 7'b0010111)? 1 : 0;

assign alu_cmd = (opcode == 7'b0110011)? 4'b0000:                           // arithmetic
                 (opcode == 7'b0010011)? 4'b0001:                           // immediate arithmetic
                 (opcode == 7'b0100011 || opcode == 7'b0000011)? 4'b0010:   // store and load
                 (opcode == 7'b1100011)? 4'b0011:                           // branch
                 (opcode == 7'b0010111)? 4'b0100:                           // jump
                 (opcode == 7'b1101111)? 4'b0101:                           // auipc  
                 4'b0000;

assign alu_src = (opcode == 7'b0100011 || opcode == 7'b0010011 || opcode == 7'b0000011)? 1 : 0;
assign pc_src = (opcode == 7'b1101111 || (opcode == 7'b1100011 && alu_flags[0]))? 1: 0;
assign rf_src = (opcode == 7'b0000011)? 1 : 0;

endmodule