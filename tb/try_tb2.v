//`timescale 1ns / 1ps

module tb_bf_radix2;

    // Signals
    reg signed [15:0] A_re;
    reg signed [15:0] B_re;
    reg signed [15:0] W_re;
    reg signed [15:0] A_im;
    reg signed [15:0] B_im;
    reg signed [15:0] W_im;
    wire signed [15:0] Y0_re;
    wire signed [15:0] Y1_re;
    wire signed [15:0] Y0_im;
    wire signed [15:0] Y1_im;

    // Instantiate the unit under test (UUT)
    bf_radix2 dut (
        .A_re(A_re),
        .B_re(B_re),
        .W_re(W_re),
        .A_im(A_im),
        .B_im(B_im),
        .W_im(W_im),
        .Y0_re(Y0_re),
        .Y1_re(Y1_re),
        .Y0_im(Y0_im),
        .Y1_im(Y1_im)
    );



    // Test cases
    initial begin
	$vcdplusfile("waveform.vpd");
        $vcdpluson();

        A_re = 16'b0000100111111100; 
	//#10;
	A_im = 16'b0_0010010_00001000;
	//#10;
	B_re = 16'b0000000000000000;  
	//#10;
	B_im = 16'b0000000000000000;
        W_re = 16'b0000000111111101;  
	//#10;
	W_im = 16'b0_0000011_00000010; 
	#10;
        $display("\nTest case 2:");
        $display("Inputs: A = %b + %bi, B = %b + %bi, W = %b + %bi", A_re, A_im, B_re, B_im, W_re, W_im);
//        $display("diff_re * W_re = %b * %b = %b", diff_re, W_re, prod_re_re);
//        $display("diff_im * W_im = %b * %b = %b", diff_im, W_im, prod_re_im);
//        $display("Y1_re = prod_re_re - prod_re_im = %b - %b = %b", prod_re_re, prod_re_im, prod_re);
	$display("Result = %b + %bi", Y1_re, Y1_im);

	// stop
        $vcdplusoff();
        $finish;	
    end
	
endmodule
