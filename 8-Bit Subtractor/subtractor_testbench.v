`timescale 1ns/100ps
`default_nettype none

module tb_rc_adder_subtractor_8bit;

    reg A0, A1, A2, A3, A4, A5, A6, A7;
    reg B0, B1, B2, B3, B4, B5, B6, B7;
    reg M;

    wire S0, S1, S2, S3, S4, S5, S6, S7;
    wire Cout, V;

    rc_adder_subtractor_8bit uut (
       .S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4), .S5(S5), .S6(S6), .S7(S7),
       .Cout(Cout), .V(V),
       .A0(A0), .A1(A1), .A2(A2), .A3(A3), .A4(A4), .A5(A5), .A6(A6), .A7(A7),
       .B0(B0), .B1(B1), .B2(B2), .B3(B3), .B4(B4), .B5(B5), .B6(B6), .B7(B7),
       .M(M)
    );

    initial begin
		$dumpfile("subtractor_waveforms.vcd");        // Name of dump file for GTKWave
		$dumpvars(0, tb_rc_adder_subtractor_8bit);    // Dump waveforms for all vars in testbench
		
        A0 = 0; A1 = 0; A2 = 0; A3 = 0; A4 = 0; A5 = 0; A6 = 0; A7 = 0;
        B0 = 0; B1 = 0; B2 = 0; B3 = 0; B4 = 0; B5 = 0; B6 = 0; B7 = 0;
        M = 0;  // M = 0 for addition, M = 1 for subtraction

        // Test addition
        #10;
        A0 = 1; A1 = 1; A2 = 1; A3 = 1; A4 = 0; A5 = 0; A6 = 0; A7 = 0;
        B0 = 1; B1 = 1; B2 = 1; B3 = 0; B4 = 0; B5 = 0; B6 = 0; B7 = 0;
        M = 0;
        #10;

        // Monitor the output values
        $display("A = %b%b%b%b%b%b%b%b, B = %b%b%b%b%b%b%b%b, M = %b", A7, A6, A5, A4, A3, A2, A1, A0, B7, B6, B5, B4, B3, B2, B1, B0, M);
        $display("S = %b%b%b%b%b%b%b%b, Cout = %b, V = %b", S7, S6, S5, S4, S3, S2, S1, S0, Cout, V);

        // Test subtraction
        #10;
        M = 1;
		#10;
        $display("A = %b%b%b%b%b%b%b%b, B = %b%b%b%b%b%b%b%b, M = %b", A7, A6, A5, A4, A3, A2, A1, A0, B7, B6, B5, B4, B3, B2, B1, B0, M);
        $display("S = %b%b%b%b%b%b%b%b, Cout = %b, V = %b", S7, S6, S5, S4, S3, S2, S1, S0, Cout, V);

        // Test a few more combinations
        #10;
        A0 = 1; A1 = 0; A2 = 1; A3 = 0; A4 = 1; A5 = 0; A6 = 1; A7 = 0;
        B0 = 0; B1 = 1; B2 = 0; B3 = 1; B4 = 0; B5 = 1; B6 = 0; B7 = 1;
        M = 0;
        #10;

        $display("A = %b%b%b%b%b%b%b%b, B = %b%b%b%b%b%b%b%b, M = %b", A7, A6, A5, A4, A3, A2, A1, A0, B7, B6, B5, B4, B3, B2, B1, B0, M);
        $display("S = %b%b%b%b%b%b%b%b, Cout = %b, V = %b", S7, S6, S5, S4, S3, S2, S1, S0, Cout, V);

        $finish;
    end
endmodule
