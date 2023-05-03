module control_mult (
    input clk,
    input start,
    output done,
    output reg op_somador,
    output reg [1:0] op_mux1,
    output reg [1:0] op_mux2,
    output reg [2:0] op_mux3,
    output reg [2:0] op_mux4,
    output reg [2:0] op_mux5
);

always @(posedge start) begin
    // Carrega valor de A
    // Carrega valor de D
    op_somador = 1;
    op_mux1 = 2'b00;
    op_mux2 = 2'b00;
    op_mux3 = 3'b000;
    op_mux4 = 3'b000;
    op_mux5 = 3'b001;

    @(posedge clk);
    // Carrega valor de B
    // Carrega valor de E
    op_mux1 = 2'b01;
    op_mux2 = 2'b01;
    op_mux3 = 3'b001;
    op_mux4 = 3'b001;
    op_mux5 = 3'b010;
    
    @(posedge clk);
    // Multiplica D e E
    // Soma A e B
    op_mux1 = 2'b10;
    op_mux2 = 2'b10;
    op_mux3 = 3'b010;
    op_mux4 = 3'b010;
    op_mux5 = 3'b000;

    @(posedge clk);
    // Subtrai de e a_b
    op_somador = 0;
    op_mux3 = 3'b011;
    op_mux4 = 3'b011;
    op_mux5 = 3'b011;

    @(posedge clk);
    // Acha resultado da multitiplicacao
    op_somador = 1;
    op_mux3 = 3'b100;
    op_mux4 = 3'b100;
    op_mux5 = 3'b100;
end

assign done = (op_mux5 == 3'b100)? 1 : 0;

endmodule