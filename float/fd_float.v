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

    fpuc fpuc (start, done, op, ula_cmd, signOfMaiorExp, signOfMenorExp, start_mult, done_mult);

    wire [7:0] expA = A[30:23];
    wire [7:0] expB = B[30:23];
    reg [7:0] menorExp;
    reg [7:0] maiorExp;
    reg [25:0] fractOfMenorExp;
    reg [25:0] fractOfmaiorExp;
    reg [25:0] possibleExp;
    reg signOfMenorExp;
    reg signOfMaiorExp;
    reg [8:0] totalShiftRight;

    always @(posedge start or posedge rst) begin
        totalShiftRight = 0;
        if (A[30:23] < B[30:23]) begin
            menorExp = A[30:23];
            maiorExp = B[30:23];    
            fractOfMenorExp = {A[22:0], 3'b0};  // Guard, round, stick bit
            fractOfmaiorExp = {B[22:0], 3'b0};  // Guard, round, stick bit
            signOfMenorExp = A[31];
            signOfMaiorExp = B[31];
        end else begin
            menorExp = B[30:23];
            maiorExp = A[30:23];
            fractOfMenorExp = {B[22:0], 3'b0}; // Guard, round, stick bit
            fractOfmaiorExp = {A[22:0], 3'b0}; // Guard, round, stick bit
            signOfMenorExp = B[31];
            signOfMaiorExp = A[31];
        end
        possibleExp = maiorExp;
    end


    // Compara expoentes
    always @* begin
        if (menorExp != maiorExp) begin
            menorExp = menorExp + 1'b1;
            totalShiftRight = totalShiftRight + 1'b1;
        end
    end

    // Deixa as duas frações com mesmo expoente
    wire [25:0] fractOfMenorExpShifed;
    wire stick;
    shifter shifterRight (fractOfMenorExp, totalShiftRight, 1'b0, stick, fractOfMenorExpShifed);

    wire [25:0] normFract = {fractOfMenorExpShifed[25:1], stick};

    wire start_mult;
    wire done_mult;
    wire carry;
    wire [1:0] ula_cmd;
    wire [25:0] result_ula;

    // Soma as frações
    ula_mult ula_mult (clk, start_mult, normFract, fractOfmaiorExp, ula_cmd, done_mult, carry, result_ula);

    // Normaliza o numero se carry == 1
    wire [7:0] expNormalized; 
    wire [25:0] fractNormalized;
    normalizer normalizer (clk, carry, result_ula, maiorExp, fractNormalized, expNormalized);

    // Arredonda o numero
    wire [7:0] roundedExp; 
    wire [25:0] roundedFract;
    arredondamento arredondamento (result_ula, maiorExp, roundedFract, roundedExp);

    // Calcula sinal
    wire signOut;
    assign signOut = (op == 2'b00)? (signOfMaiorExp == signOfMenorExp)? signOfMenorExp : // soma sinais iguais
                    (normFract < fractOfmaiorExp)? signOfMaiorExp : signOfMenorExp : // soma sinais diferentes
                    (signOfMaiorExp == signOfMenorExp)? 1'b0 : 1'b1; // sinal da multiplicacao

    // output
    assign R = {signOut, roundedExp, roundedFract};

endmodule