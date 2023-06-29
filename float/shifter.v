module shifter (
    input [26:0] a,
    input [8:0] shift,
    input lado, // 1 para esqueda
    output stick,
    output [26:0] out
);

wire [26:0] forStick;
wire [26:0] rightShift;

assign {rightShift, forStick} = {a, 27'b0} >> shift;
assign stick = rightShift[0] || forStick;

assign out = (lado)? a << shift : rightShift; 

endmodule