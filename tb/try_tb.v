
module tb_bf_radix2_noW();

    // Signals
    reg signed [15:0] A_re;
    reg signed [15:0] B_re;
    reg signed [15:0] A_im;
    reg signed [15:0] B_im;
    wire signed [15:0] Y0_re;
    wire signed [15:0] Y1_re;
    wire signed [15:0] Y0_im;
    wire signed [15:0] Y1_im;

    // Instantiate the unit under test (UUT)
    bf_radix2_noW DUT(
        .A_re(A_re),
        .B_re(B_re),
        .A_im(A_im),
        .B_im(B_im),
        .Y0_re(Y0_re),
        .Y1_re(Y1_re),
        .Y0_im(Y0_im),
        .Y1_im(Y1_im)
    );


    // Test stimulus
    initial begin
	$vcdplusfile("waveform.vpd");
        $vcdpluson();
        // Apply test vectors
        A_re = 16; 
#10;
A_im = 10;
#10;
        B_re = 8;
#10;
B_im = 4;
        #10;
        // Print results
        $display("===============================A_re = %d, A_im = %d, B_re = %d, B_im = %d", A_re, A_im, B_re, B_im);
        $display("Y0_re = %d, Y0_im = %d, Y1_re = %d, Y1_im = %d", Y0_re, Y0_im, Y1_re, Y1_im);

	// stop
        $vcdplusoff();
        $finish;	
    end

endmodule
