module fpu (
    input clk,
    input rst,
    input [31:0] A,
    input [31:0] B, 
    output [31:0] R,
    input [1:0] op,
    input start,
    output done
);

    fpuc fpuc (start, done, op, ula_cmd, signOfMaiorExp, signOfMenorExp, diferenSigns, start_mult, done_mult);

    wire [7:0] expA = A[30:23];
    wire [7:0] expB = B[30:23];
    reg [7:0] menorExp;
    reg [7:0] maiorExp;
    reg [26:0] fractOfMenorExp;
    reg [26:0] fractOfmaiorExp;
    reg [7:0] possibleExp;
    reg signOfMenorExp;
    reg signOfMaiorExp;
    reg [8:0] totalShiftRight;

    always @(posedge start or posedge rst) begin
        totalShiftRight = 0;
        if (A[30:23] < B[30:23]) begin
            menorExp = A[30:23];
            maiorExp = B[30:23];    
            fractOfMenorExp = {1'b1, A[22:0], 3'b0};  //first: hidden bit | lasts: Guard, round, stick bit
            fractOfmaiorExp = {1'b1, B[22:0], 3'b0};  //first: hidden bit | lasts: Guard, round, stick bit
            signOfMenorExp = A[31];
            signOfMaiorExp = B[31];
        end else begin
            menorExp = B[30:23];
            maiorExp = A[30:23];
            fractOfMenorExp = {1'b1, B[22:0], 3'b0}; // first: hidden bit | lasts: Guard, round, stick bit
            fractOfmaiorExp = {1'b1, A[22:0], 3'b0}; // first: hidden bit | lasts: Guard, round, stick bit
            signOfMenorExp = B[31];
            signOfMaiorExp = A[31];
        end
        possibleExp = maiorExp;
    end


    // Compara expoentes
    integer i;
    always @* begin
        for (i = 0; (menorExp + i) != maiorExp; i = i + 1) begin
            totalShiftRight = totalShiftRight + 1'b1;
        end
    end

    // Deixa as duas frações com mesmo expoente
    wire [26:0] fractOfMenorExpShifed;
    wire stick;
    shifter shifterRight (fractOfMenorExp, totalShiftRight, 1'b0, stick, fractOfMenorExpShifed);

    wire [26:0] normFract = {fractOfMenorExpShifed[26:1], stick};

    wire start_mult;
    wire done_mult;
    wire carry;
    wire [1:0] ula_cmd;
    wire [26:0] result_ula;

    // Soma as frações
    ula_mult ula_mult (clk, start_mult, normFract, fractOfmaiorExp, ula_cmd, done_mult, carry, result_ula);

    // Normaliza o numero se hidden bit != 1
    wire [7:0] expNormalized; 
    wire [26:0] fractNormalized;
    wire diferenSigns;
    normalizer normalizer (clk, carry, diferenSigns, result_ula, possibleExp, fractNormalized, expNormalized);

    // Arredonda o numero
    wire [7:0] roundedExp; 
    wire [26:0] roundedFract;
    arredondamento arredondamento (fractNormalized, expNormalized, roundedFract, roundedExp);

    // Calcula sinal
    wire signOut;
    assign signOut = (op == 2'b00)? (signOfMaiorExp == signOfMenorExp)? signOfMenorExp : // soma sinais iguais
                    (normFract < fractOfmaiorExp)? signOfMaiorExp : signOfMenorExp : // soma sinais diferentes
                    (signOfMaiorExp == signOfMenorExp)? 1'b0 : 1'b1; // sinal da multiplicacao

    // output
    assign R = {signOut, roundedExp, roundedFract[25:3]};

endmodule