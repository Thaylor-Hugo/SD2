// Grupo 5
// Nomes:
// Thaylor Hugo - 13684425 
// Felipe Soria - 13864287
// Alejandro Larrea - 13791522  
// Data: 30/06

// Float Point Unit
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
    wire [1:0] ula_cmd;
    wire diferenSigns;
    wire signOfMaiorExp;
    wire signOfMenorExp;
    wire start_mult;
    wire doneUla;
    wire loadRegs;
    wire startUla;
    wire normalize;
    wire toRound;
    wire final;

    fp_uc fp_uc (clk, start, rst, done, op, ula_cmd, signOfMaiorExp, signOfMenorExp, diferenSigns, doneUla, loadRegs, startUla, normalize, toRound, final);
    fp_dp fp_dp (clk, rst, A, B, R, op, ula_cmd, signOfMaiorExp, signOfMenorExp, diferenSigns, doneUla, loadRegs, startUla, normalize, toRound, final);

endmodule

// Float Point Control Unit
module fp_uc (
    input clk,
    input start, 
    input rst,
    output reg done,
    input [1:0] op,
    output reg [1:0] ula_cmd,
    input signOfMaiorExp,
    input signOfMenorExp,
    output diferenSigns,
    input doneUla,
    output reg loadRegs,
    output reg startUla,
    output reg normalize,
    output reg toRound,
    output reg final );

    assign diferenSigns = (signOfMaiorExp == signOfMenorExp)? 0 : 1;

    reg [2:0] state;

    always @(posedge clk or posedge start or posedge rst) begin
        if (start) begin
            done = 0;
            state = 0;
        end
        if (rst) begin
            state = 3'b111;
        end
        case (state)
            3'b000: begin
                // Compare exponents and match mantissas
                loadRegs = 1;
                startUla = 0;
                normalize = 0;
                toRound = 0;
                final = 0;
                state = 3'b001;
            end
            3'b001: begin
                // Soma ou multiplica fração
                if (op == 2'b10) begin
                    ula_cmd = 2'b0;
                end else begin
                    if (signOfMaiorExp == signOfMenorExp) begin
                        ula_cmd = 2'b01;    // sinais iguais faz soma
                    end else begin
                        ula_cmd = 2'b10;    // sinais diferentes faz sub
                    end
                end
                loadRegs = 0; 
                startUla = 1;
                normalize = 0;
                toRound = 0;
                final = 0;
                state = 3'b010;
            end
            3'b010: begin
                // Checks se Ula terminou operação
                if (doneUla) begin
                    state = 3'b011;
                end
                loadRegs = 0; 
                startUla = 0;
                normalize = 0;
                toRound = 0;
                final = 0;
            end
            3'b011: begin
                if (doneUla) begin
                    state = 3'b011;
                end
                // Normalize number
                loadRegs = 0; 
                startUla = 0;
                normalize = 1;
                toRound = 0;
                final = 0;
                state = 3'b100;
            end
            3'b100: begin
                // Round Number
                loadRegs = 0; 
                startUla = 0;
                normalize = 0;
                toRound = 1;
                final = 0;
                state = 3'b101;
            end
            3'b101: begin
                // Libera resultado
                loadRegs = 0; 
                startUla = 0;
                normalize = 0;
                toRound = 0;
                final = 1;
                done = 0;
                state = 3'b110;
            end
            3'b110: begin
                // Done
                loadRegs = 0; 
                startUla = 0;
                normalize = 0;
                toRound = 0;
                final = 0;
                done = 1;
            end
            3'b111: begin
                loadRegs = 0; 
                startUla = 0;
                normalize = 0;
                toRound = 0;
            end
            default: begin
                loadRegs = 0; 
                startUla = 0;
                normalize = 0;
                toRound = 0;
                done = 0;
            end 
        endcase
    end
endmodule

// Float Point Datapath
module fp_dp (
    input clk, 
    input rst, 
    input [31:0] A, B, 
    output [31:0] R, 
    input [1:0] op,
    input [1:0] ula_cmd, 
    output signOfMaiorExp, signOfMenorExp,
    input diferenSigns, 
    output doneUla,
    input loadRegs,
    input startUla,
    input normalize,
    input toRound,
    input final );

    reg [7:0] menorExp;
    reg [7:0] maiorExp;
    reg [26:0] fractOfMenorExp;
    reg [26:0] fractOfmaiorExp;
    reg [7:0] possibleExp;
    reg signOfMenorExp;
    reg signOfMaiorExp;
    reg [31:0] floatOut;

    // Load regs on start
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            menorExp = 0;
            maiorExp = 0;    
            fractOfMenorExp = 0;  //first: hidden bit | lasts: Guard, round, stick bit
            fractOfmaiorExp = 0;  //first: hidden bit | lasts: Guard, round, stick bit
            signOfMenorExp = 0;
            signOfMaiorExp = 0;
            possibleExp = 0;
            floatOut = 0;
        end else if (loadRegs) begin
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
            if (op == 2'b10) begin
                possibleExp = maiorExp + menorExp - 8'd127;
            end else begin
                possibleExp = maiorExp;
            end
        end 
    end

    // Compara expoentes
    wire [8:0] totalShiftRight;
    assign totalShiftRight = (op == 2'b10)? 0 : maiorExp - menorExp;

    // Deixa as duas frações com mesmo expoente
    wire [26:0] fractOfMenorExpShifed;
    wire stick;
    shifter shifterRight (fractOfMenorExp, totalShiftRight, 1'b0, stick, fractOfMenorExpShifed);

    wire [26:0] normFract = {fractOfMenorExpShifed[26:0]};

    wire carry;
    wire [26:0] result_ula;

    // Manda mantissa normalizada pra ula se ADD ou mantissa original se Mult
    wire [26:0] ulaEntry = (op == 2'b10)? fractOfMenorExp : normFract;

    // Soma as frações
    ula_mult ula_mult (clk, startUla, ulaEntry, fractOfmaiorExp, ula_cmd, doneUla, carry, result_ula);

    // Normaliza o numero se hidden bit != 1
    wire [7:0] expNormalized; 
    wire [26:0] fractNormalized;
    wire diferenSigns;
    normalizer normalizer (clk, op, normalize, carry, diferenSigns, result_ula, possibleExp, fractNormalized, expNormalized);

    // Arredonda o numero
    wire [7:0] roundedExp; 
    wire [26:0] roundedFract;
    arredondamento arredondamento (toRound, fractNormalized, expNormalized, roundedFract, roundedExp);

    // Calcula sinal
    wire signOut;
    assign signOut = (op == 2'b00 || op == 2'b01)? (!diferenSigns)? signOfMenorExp : // soma/sub sinais iguais
                    (normFract < fractOfmaiorExp)? signOfMaiorExp : signOfMenorExp : // soma/sub sinais diferentes
                    (diferenSigns)? 1'b1 : 1'b0; // sinal da multiplicacao

    // output

    always @(posedge final) begin
        floatOut = {signOut, roundedExp, roundedFract[25:3]};
    end

    assign R = floatOut;
endmodule

// Ula para soma e multiplicação
module ula_mult (
    input clk,
    input start,
    input [26:0] a,
    input [26:0] b,
    input [1:0] cmd,    // 10 e sub, 1 se soma, 0 se mult
    output done,
    output carry,
    output [26:0] result );

    reg [53:0] multiplicacao;
    reg [26:0] menor;
    reg [26:0] maior;
    reg [4:0] i;        // Qual bit de "menor" estamos analisando

    always @(posedge start) begin
        if (a < b) begin
            maior <= b;
            menor <= a;
        end else begin
            maior <= a;
            menor <= b;
        end
        multiplicacao <= 0;
        i <= 0;
    end

    //multiplicação
    always @(posedge clk) begin
        if (i<'d27) begin
            if (menor[i]) begin    
                multiplicacao <= multiplicacao + (maior << i);      
            end
            i <= i+1;
        end
    end

    assign done = (cmd == 2'b0 && i == 'd27)? 1'b1 : (cmd == 2'b0 && i != 'd27)? 1'b0 : 1'b1;

    wire [26:0] sum;
    wire [26:0] sub;

    assign {carry, sum} = a + b;
    assign sub = (a > b)? a - b : b - a;
    assign carry = (cmd == 0)? multiplicacao[53] : carry;

    assign result = (cmd == 2'b10)? sub: (cmd == 2'b01)? sum : multiplicacao[52:26];
endmodule

// Normalizor de float point (força hidden bit == 1)
module normalizer (
    input clk,
    input [1:0]op,
    input normalize,
    input carry,
    input diferenSigns,
    input [26:0] possibleFract,
    input [7:0] possibleExp,
    output reg [26:0] fractNormalized,
    output reg [7:0] expNormalized );

    wire [4:0] totalShiftLeft;

    // Check first bit 1 on fract
    firstSet firstSet (possibleFract, totalShiftLeft);

    always @(posedge normalize) begin
        // Shift fract até hidden bit == 1 e normalize exp conforme necessario
        if ((op!=2'b10 && carry && !diferenSigns) || (op==2'b10 && carry)) begin
            fractNormalized = possibleFract >> 1'b1;
            expNormalized = possibleExp + 1'b1;
        end else begin
            fractNormalized = possibleFract << totalShiftLeft;
            expNormalized = possibleExp - totalShiftLeft;
        end
    end
endmodule

// Retorna posição do primeiro bit um da entrada a partir do MSB
module firstSet (
    input [26:0] a,
    output reg [4:0] addr );

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

// Arredonda um numero de ponto flutuante
module arredondamento (
    input toRound,
    input [26:0] fract,
    input [7:0] exp,
    output reg [26:0] fract_out,
    output reg [7:0] exp_out );

    wire round = fract[2];
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
    wire newRound = normFract[2];
    wire [25:0] newRounded = (newRound)? normFract + 4'b1000 : {1'b0, normFract};

    // output
    always @(posedge toRound) begin
        exp_out = normExp;
        if (carry) begin
            fract_out = newRounded;
        end else begin
            fract_out = rounded;
        end
    end
endmodule

// Shifta um numero, com setor de quantidade e lado
module shifter (
    input [26:0] a,
    input [8:0] shift,
    input lado, // 1 para esqueda
    output stick,
    output [26:0] out );

    wire [26:0] forStick;
    wire [26:0] rightShift;

    assign {rightShift, forStick} = {a, 27'b0} >> shift;
    assign stick = rightShift[0] || forStick;

    assign out = (lado)? a << shift : rightShift; 
endmodule
