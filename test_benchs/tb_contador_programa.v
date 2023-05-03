`timescale 1ns/1ps

module tb_contador_programa;

    reg reset, branch, jump, jr;
    reg [15:0] data_reg_jump;
    reg [12:0] target_jump;
    reg [15:0] immediato_extended;
    wire [15:0] endereco;

    reg clock = 0;
    always #1 clock = !clock;

    initial begin
        $dumpfile("tb_contador_programa.vcd");
        $dumpvars(0,tb_contador_programa);
    end

    contador_programa contador_programa (clock, reset, branch, jump, jr, data_reg_jump, 
                                            target_jump, immediato_extended, endereco);
    initial begin
        #3 reset = 1;
        #10 reset = 0;
        data_reg_jump = 16'd16;     /* Quando jr==1, PC deve ir para endereco 16 */
        target_jump = 16'd23;       /* Quando jump==1, PC deve ir para endereco 46 */
        immediato_extended = 13'd7; /* Quando branch==1, PC deve avancar 14 enderecos */
        branch = 0;                 /* No padrao, PC deve ir para PC + 2 */
        jump = 0;
        jr = 0;
        #10 jump = 1;
        #2 jump = 0;
        #10 branch = 1;
        #2 branch = 0;
        #10 jr = 1;
        #2 jr = 0;
        #10 reset = 1;
        #10 $finish;
    end 

    initial begin
        $monitor("clock=%d | reset=%d | branch=%d | jump=%d | jr=%d | data_reg=%d | target=%d | immed=%d | endereco=%d", 
                    clock, reset, branch, jump, jr, data_reg_jump, target_jump, immediato_extended, endereco);
    end
    
endmodule