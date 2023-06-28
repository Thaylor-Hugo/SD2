module fpuc (
    input start, 
    output done,
    input [1:0] op,
    output reg [1:0] ula_cmd,
    input signOfMaiorExp,
    input signOfMenorExp,
    output reg start_mult, 
    input done_mult
);

always @(posedge start) begin
    if (op == 2'b10) begin
        start_mult = 1;
        ula_cmd = 2'b0;
    end else begin
        start_mult = 0;
        if (signOfMaiorExp == signOfMenorExp) begin
            ula_cmd = 2'b01;
        end else begin
            ula_cmd = 2'b10;
        end
    end
end
    
endmodule