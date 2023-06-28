module normalizer (
    input clk,
    input carry,
    input [25:0] possibleFract,
    input [7:0] possibleExp,
    output [25:0] fractNormalized,
    output [7:0] expNormalized
);

assign fractNormalized = (carry)? possibleFract >> 1'b1 : possibleFract;
assign expNormalized = (carry)? possibleExp + 1'b1 : possibleExp;

endmodule