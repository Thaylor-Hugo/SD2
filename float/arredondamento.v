module arredondamento (
    input [26:0] fract,
    input [7:0] exp,
    output [26:0] fract_out,
    output [7:0] exp_out
);
    wire round = fract[2] & (fract[3] || (fract[0] || fract[1]));
    wire carry;
    wire [26:0] rounded;
    
    // Round number
    assign {carry, rounded} = (round)? fract + 4'b1000 : {1'b0, fract};

    // If carry, normalize again
    wire [7:0] normExp;
    wire [26:0] normFract;

    assign normExp = (carry)? exp + 1'b1 : exp;
    assign normFract = (carry)? rounded >> 1'b1 : rounded;

    // Round after normalized
    wire newRound = normFract[2] & (normFract[3] || (normFract[0] || normFract[1]));
    wire [25:0] newRounded = (newRound)? normFract + 4'b1000 : {1'b0, normFract};

    // output
    assign fract_out = (carry)? newRounded : rounded;
    assign exp_out = normExp;
    
    // wire [25:0] aux_fract;
    
    // assign aux_fract = (fract[2:0] > 3'b100)? fract + 1'b1 :
    //                    (fract[2:0] < 3'b100)? fract :
    //                    (fract[3] == 0)? fract : fract + 1'b1;

    // assign fract_out = (fract[25])? aux_fract[25:3] :
    //                    (fract[24])? aux_fract[24:2] :
    //                    (fract[23])? aux_fract[23:1] :
    //                    fract[22:0];

    // assign exp_out =    (fract[25])? exp + 2'b11 :
    //                     (fract[24])? exp + 2'b10 :
    //                     (fract[23])? exp + 2'b01 :
    //                     exp;

endmodule