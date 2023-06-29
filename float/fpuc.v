module fpuc (
    input start, 
    output reg done,
    input [1:0] op,
    output reg [1:0] ula_cmd,
    input signOfMaiorExp,
    input signOfMenorExp,
    output reg diferenSigns,
    output reg start_mult, 
    input done_mult
);

always @(posedge start) begin
    done = 0;
    if (op == 2'b10) begin
        start_mult = 1;
        ula_cmd = 2'b0;
    end else begin
        start_mult = 0;
        if (signOfMaiorExp == signOfMenorExp) begin
            ula_cmd = 2'b01;    // sinais iguais faz soma
            diferenSigns = 0;
        end else begin
            ula_cmd = 2'b10;    // sinais diferentes faz sub
            diferenSigns = 1;
        end
    end
end

always @(posedge start) begin
    
end
    
endmodule