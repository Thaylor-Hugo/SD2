module shifter (
    input [25:0] a,
    input [8:0] shift,
    input lado, // 1 para esqueda
    output stick,
    output [25:0] out
);

wire [25:0] forStick;
wire [25:0] rightShift;

assign {rightShift, forStick} = {a, 26'b0} >> shift;
assign stick = rightShift[0] || forStick;

assign out = (lado)? a << shift : rightShift; 

endmodule