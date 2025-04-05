`timescale 1ns/100ps
`default_nettype none

module full_adder(
    output wire S,
    output wire Cout,
    input wire a,
    input wire b,
    input wire Cin
);

    assign S = (a ^ b) ^ Cin;
    assign Cout = ((a ^ b) & Cin) | (a & b);
    
endmodule

module rc_adder_subtractor_8bit(
    output wire S0, S1, S2, S3, S4, S5, S6, S7,
    output wire Cout,
    output wire V,
    input wire A0, A1, A2, A3, A4, A5, A6, A7,
    input wire B0, B1, B2, B3, B4, B5, B6, B7,
    input wire M
);

    wire C1, C2, C3, C4, C5, C6, C7;
    wire W0, W1, W2, W3, W4, W5, W6, W7;

    xor G0 (W0, B0, M);
    xor G1 (W1, B1, M);
    xor G2 (W2, B2, M); 
    xor G3 (W3, B3, M);
    xor G4 (W4, B4, M);
    xor G5 (W5, B5, M);
    xor G6 (W6, B6, M);
    xor G7 (W7, B7, M);
    xor G8 (V, C7, Cout);

    full_adder FA0 (
        .S(S0), .Cout(C1), .a(A0),
        .b(W0), .Cin(M)
    );

    full_adder FA1 (
        .S(S1), .Cout(C2), .a(A1),
        .b(W1), .Cin(C1)
    );

    full_adder FA2 (
        .S(S2), .Cout(C3), .a(A2),
        .b(W2), .Cin(C2)
    );
    
    full_adder FA3 (
        .S(S3), .Cout(C4), .a(A3),
        .b(W3), .Cin(C3)
    );

    full_adder FA4 (
        .S(S4), .Cout(C5), .a(A4),
        .b(W4), .Cin(C4)
    );

    full_adder FA5 (
        .S(S5), .Cout(C6), .a(A5),
        .b(W5), .Cin(C5)
    );

    full_adder FA6 (
        .S(S6), .Cout(C7), .a(A6),
        .b(W6), .Cin(C6)
    );

    full_adder FA7 (
        .S(S7), .Cout(Cout), .a(A7),
        .b(W7), .Cin(C7)
    );

endmodule
