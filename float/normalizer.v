module normalizer (
    input clk,
    input carry,
    input diferenSigns,
    input [26:0] possibleFract,
    input [7:0] possibleExp,
    output [26:0] fractNormalized,
    output [7:0] expNormalized
);

reg [26:0] newFract;
reg [7:0] newExp;
wire [4:0] totalShiftLeft;

firstSet firstSet (possibleFract, totalShiftLeft);

always @(*) begin
    if (carry && !diferenSigns) begin
        newFract = possibleFract >> 1'b1;
        newExp = possibleExp + 1'b1;
    end else begin
        newFract = possibleFract << totalShiftLeft;
        newExp = possibleExp - totalShiftLeft;
        // for (i = 26; possibleFract[i] != 1 && i >= 0; i = i - 1) begin
        //     newFract = possibleFract << (26 - i);
        //     newExp = possibleExp - (26 - i);
        // end
    end
end

assign fractNormalized = newFract;
assign expNormalized = newExp;

// assign fractNormalized = (carry)? possibleFract >> 1'b1 : possibleFract >> 1'b1;
// assign expNormalized = (carry)? possibleExp + 1'b1 : possibleExp + 1'b1;

endmodule

module firstSet (
    input [26:0] a,
    output reg [4:0] addr
);

always @(*) begin
    if (a[26] == 1) addr = 5'b0;
    else if (a[25] == 1) addr = 5'd1;
    else if (a[24] == 1) addr = 5'd2;
    else if (a[23] == 1) addr = 5'd3;
    else if (a[22] == 1) addr = 5'd4;
    else if (a[21] == 1) addr = 5'd5;
    else if (a[20] == 1) addr = 5'd6;
    else if (a[19] == 1) addr = 5'd7;
    else if (a[18] == 1) addr = 5'd8;
    else if (a[17] == 1) addr = 5'd9;
    else if (a[16] == 1) addr = 5'd10;
    else if (a[15] == 1) addr = 5'd11;
    else if (a[14] == 1) addr = 5'd12;
    else if (a[13] == 1) addr = 5'd13;
    else if (a[12] == 1) addr = 5'd14;
    else if (a[11] == 1) addr = 5'd15;
    else if (a[10] == 1) addr = 5'd16;
    else if (a[9] == 1) addr = 5'd17;
    else if (a[8] == 1) addr = 5'd18;
    else if (a[7] == 1) addr = 5'd19;
    else if (a[6] == 1) addr = 5'd20;
    else if (a[5] == 1) addr = 5'd21;
    else if (a[4] == 1) addr = 5'd22;
    else if (a[3] == 1) addr = 5'd23;
    else if (a[2] == 1) addr = 5'd24;
    else if (a[1] == 1) addr = 5'd25;
    else if (a[0] == 1) addr = 5'd26;
end
    
endmodule