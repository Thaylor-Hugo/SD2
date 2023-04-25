// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  

module tb_somador;
    
    reg signed [15:0] a, b; 
    reg op;
    wire overflow;
    wire signed [15:0] result;
    

    initial begin
        $dumpfile("tb_somador.vcd");
        $dumpvars(0,tb_somador);
    end

    somador somador(a, b, op, overflow, result);

    initial begin
        
        #1;
        op = 1;  //soma
        a = 16'b0000000000100011;   //35
        b = 16'b0000000001001000;   //72
        #1;
        
        #1;
        op = 1;  //soma
        a = 16'b0111111100000000;   // 32512
        b = 16'b0000000100000000;   // 256
        #1; // overflow
        
        #1;
        op = 1;  //soma
        a = 16'b1010101010101010;   // -21846
        b = 16'b1110001000000000;   // -7680
        #1;
        
        #1;
        op = 0;  //sub
        a = 16'b1111111100000000;   // -256 
        b = 16'b0000000100000000;   // 256
        #1; //

        #1;
        op = 0;  //sub
        a = 16'b0000000111110110;   // 502
        b = 16'b0000000001111100;   // 124
        #1;

        #1;
        op = 0;  //sub
        a = 16'b1001000001100000;   // -28576
        b = 16'b0110010000000100;   // 25604
        #1;

        #2 $finish;

    end

    initial begin
        $monitor("a = %d | b = %d | result = %d | op = %d | overflow = %d", a, b, result, op, overflow);
    end


endmodule