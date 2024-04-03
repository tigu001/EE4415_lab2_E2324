////////////////////////////////////////////////////////////////
// input ports
// clk               -clock signal
// arstn             -reset the system (asynchronous reset, active low)
// ifft_in0_re       -from testbench, test cases for the of the 1st input (real part) of the IFFT pipeline (32 elements * 16 bits = 512 bits)
// ifft_in0_im       -from testbench, test cases for the of the 2nd input (imag part) of the IFFT pipeline (32 elements * 16 bits = 512 bits)
// ifft_in1_re       -from testbench, test cases for the of the 1st input (real part) of the IFFT pipeline (32 elements * 16 bits = 512 bits)
// ifft_in1_im       -from testbench, test cases for the of the 2nd input (imag part) of the IFFT pipeline (32 elements * 16 bits = 512 bits)
// twiddle_lut_re    -from testbench, twiddle factors needed during 64IFFT calculation (32 elements * 16 bits = 512 bits)
// twiddle_lut_im    -from testbench, twiddle factors needed during 64IFFT calculation (32 elements * 16 bits = 512 bits)
// twiddle_sel1      -control signal, to select twiddle factors for the 1st layer in the 64IFFT pipeline
// twiddle_sel2      -control signal, to select twiddle factors for the 2nd layer in the 64IFFT pipeline
// twiddle_sel3      -control signal, to select twiddle factors for the 3rd layer in the 64IFFT pipeline
// twiddle_sel4      -control signal, to select twiddle factors for the 4th layer in the 64IFFT pipeline
// twiddle_sel5      -control signal, to select twiddle factors for the 5th layer in the 64IFFT pipeline
// pattern2          -control signal, to contol the communator at the 2nd layer in the 64IFFT pipeline
// pattern3          -control signal, to contol the communator at the 3rd layer in the 64IFFT pipeline
// pattern4          -control signal, to contol the communator at the 4th layer in the 64IFFT pipeline
// pattern5          -control signal, to contol the communator at the 5th layer in the 64IFFT pipeline
// pattern6          -control signal, to contol the communator at the 6th layer in the 64IFFT pipeline
// cnt_cal           -to counter 32 cycles within each test case (5 bits)

// output ports
// ifft_out0_re      -to testbench, the 1st output (real part) of the IFFT pipeline (16 bits)
// ifft_out0_im      -to testbench, the 1st output (imag part) of the IFFT pipeline (16 bits) 
// ifft_out1_re      -to testbench, the 2nd output (real part) of the IFFT pipeline (16 bits) 
// ifft_out1_im      -to testbench, the 2nd output (imag part) of the IFFT pipeline (16 bits) 
////////////////////////////////////////////////////////////////
module ifft64_radix2
    (
        //from tb
        input clk, 
        input arstn,
        input [511:0] ifft_in0_re,
        input [511:0] ifft_in0_im,
        input [511:0] ifft_in1_re,
        input [511:0] ifft_in1_im,
        input [511:0] twiddle_lut_re,
        input [511:0] twiddle_lut_im,
        //from ctrl
        input [4:0] twiddle_sel1,
        input [4:0] twiddle_sel2,
        input [4:0] twiddle_sel3,
        input [4:0] twiddle_sel4,
        input [4:0] twiddle_sel5,
        input pattern2,
        input pattern3,
        input pattern4,
        input pattern5,
        input pattern6,
        input [4:0] cnt_cal,
        //outputs
        output [15:0] ifft_out0_re,
        output [15:0] ifft_out0_im,
        output [15:0] ifft_out1_re,
        output [15:0] ifft_out1_im
    );

// wire definition
wire [15:0] bf1_in0_re, bf1_in0_im, bf1_in1_re, bf1_in1_im, bf1_out0_re, bf1_out0_im, bf1_out1_re, bf1_out1_im;
wire [15:0] bf2_in0_re, bf2_in0_im, bf2_in1_re, bf2_in1_im, bf2_out0_re, bf2_out0_im, bf2_out1_re, bf2_out1_im;
wire [15:0] bf3_in0_re, bf3_in0_im, bf3_in1_re, bf3_in1_im, bf3_out0_re, bf3_out0_im, bf3_out1_re, bf3_out1_im;
wire [15:0] bf4_in0_re, bf4_in0_im, bf4_in1_re, bf4_in1_im, bf4_out0_re, bf4_out0_im, bf4_out1_re, bf4_out1_im;
wire [15:0] bf5_in0_re, bf5_in0_im, bf5_in1_re, bf5_in1_im, bf5_out0_re, bf5_out0_im, bf5_out1_re, bf5_out1_im;
wire [15:0] bf6_in0_re, bf6_in0_im, bf6_in1_re, bf6_in1_im, bf6_out0_re, bf6_out0_im, bf6_out1_re, bf6_out1_im;

wire [15:0] cm1_in0_re, cm1_in0_im, cm1_in1_re, cm1_in1_im, cm1_out0_re, cm1_out0_im, cm1_out1_re, cm1_out1_im;
wire [15:0] cm2_in0_re, cm2_in0_im, cm2_in1_re, cm2_in1_im, cm2_out0_re, cm2_out0_im, cm2_out1_re, cm2_out1_im;
wire [15:0] cm3_in0_re, cm3_in0_im, cm3_in1_re, cm3_in1_im, cm3_out0_re, cm3_out0_im, cm3_out1_re, cm3_out1_im;
wire [15:0] cm4_in0_re, cm4_in0_im, cm4_in1_re, cm4_in1_im, cm4_out0_re, cm4_out0_im, cm4_out1_re, cm4_out1_im;
wire [15:0] cm5_in0_re, cm5_in0_im, cm5_in1_re, cm5_in1_im, cm5_out0_re, cm5_out0_im, cm5_out1_re, cm5_out1_im;
wire [15:0] cm6_in0_re, cm6_in0_im, cm6_in1_re, cm6_in1_im, cm6_out0_re, cm6_out0_im, cm6_out1_re, cm6_out1_im;

wire [511: 0] ifft_in0_re, ifft_in0_im, ifft_in1_re, ifft_in1_im;

// *Block 0* input MUX
// Depends on cnt_cal, to select inputs for the IFFT pipeline at each cycle
// input: 512 bits, ifft_in0_re, ifft_in0_im, ifft_in1_re, ifft_in1_im
// output: 16 bits, bf1_in0_re, bf1_in0_im, bf1_in1_re, bf1_in1_im
// selection signal: cnt_cal (e.g. when cnt_cal = 0,  bf1_in0_re = ifft_in0_re[32*16-1:31*16], ..., bf1_in0_im = ifft_in0_im[32*16-1:31*16], ...
//                                 when cnt_cal = 31, bf1_in0_re = ifft_in0_re[ 1*16-1: 0*16], ..., bf1_in0_im = ifft_in0_im[ 1*16-1: 0*16], ...)
// when cnt_cal = 0, bf1_in1_re[1*16-1:0*16]
// fill in your code here
assign bf1_in0_re = ifft_in0_re[(32-cnt_cal)*16-1:(31-cnt_cal)*16];
assign bf1_in0_im = ifft_in0_im[(32-cnt_cal)*16-1:(31-cnt_cal)*16];
assign bf1_in1_re = ifft_in1_re[(32-cnt_cal)*16-1:(31-cnt_cal)*16];
assign bf1_in1_im = ifft_in1_im[(32-cnt_cal)*16-1:(31-cnt_cal)*16];

// layer 1
    // twiddle factor MUX, depends on twiddle_sel1, to select twiddle factors for the 1st layer of the 64IFFT pipeline
    // input: 512 bits, twiddle_lut_re, twiddle_lut_im
    // output: 16 bits, twiddle1_re, twiddle1_im
    // W-0 > 511:511-16
    // fill in your code here

    assign twiddle1_re = twiddle_lut_re[(32-twiddle_sel1)*16-1:(31-twiddle_sel1)*16];
    assign twiddle1_im = twiddle_lut_im[(32-twiddle_sel1)*16-1:(31-twiddle_sel1)*16];

    // butterfly radix calculation with twiddle factor
    // Y0 = A + B
    // Y1 = (A - B)*W
    // instantiate your bf_radix2.v here
    // fill in your code here
    bf_radix2 layer1(
        .A_re(bf1_in0_re),
        .B_re(bf1_in1_re),
        .W_re(twiddle1_re),
        .A_im(bf1_in0_im),
        .B_im(bf1_in1_im),
        .W_im(twiddle1_im),
        .Y0_re(bf1_out0_re),
        .Y1_re(bf1_out1_re),
        .Y0_im(bf1_out0_im),
        .Y1_im(bf1_out1_im)
    );


    // 16 buffer for bf1_out1 here
    // fill in your code here
    reg [15:0] a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15;
    reg [15:0] b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15;
    always @(posedge clk or negedge arstn) begin
        // if (arstn = 0)a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15 = 0
	// if (arstn ==1)
	a1 <= cm1_in1_re; 
	a2 = a1;
	a3 = a2;
	a4 = a3;
	a5 = a4;
	a6 = a5; 
	a7 = a6;
	a8 = a7;
	a9 = a8;
	a10 = a9;
	a11 = a10;
	a12 = a11;
	a13 = a12;
	a14 = a13;
	a15 = a14;
	bf1_out0_re = a15;

        b1 = cm1_in1_re; 
	b2 = b1;
	b3 = b2;
	b4 = b3;
	b5 = b4;
	b6 = b5; 
	b7 = b6;
	b8 = b7;
	b9 = b8;
	b10 = b9;
	b11 = b10;
	b12 = b11;
	b13 = b12;
	b14 = b13;
	b15 = b14;
	bf1_out0_im = b15;
    end

    assign cm1_in0_re = bf1_out0_re;
    assign cm1_in0_im = bf1_out0_im;

    // Communator code here
    commutator_radix2 layer1(
        .in_0_re(cm1_in0_re),
        .in_0_im(cm1_in0_im),
        .in_1_re(cm1_in1_re),
        .in_1_im(cm1_in1_im),
        .pattern(pattern2),
        .out_0_re(cm1_out0_re),
        .out_0_im(cm1_out0_im),
        .out_1_re(cm1_out1_re),
        .out_1_im(cm1_out1_im)
    );


    // Add 16 buffer to cm1_out0
//???
assign bf2_in0_re = ;
assign bf2_in0_im = ;
assign bf2_in1_re = ;
assign bf2_in1_im = ;

//layer 2
    // twiddle factor MUX, depends on twiddle_sel2, to select twiddle factors for the 2nd layer of the 64IFFT pipeline
    // input: 512 bits, twiddle_lut_re, twiddle_lut_im
    // output: 16 bits, twiddle2_re, twiddle2_im
    // fill in your code here


    //re-arrange data
        // delay before commutator
        // fill in your code here


        // commutator
        // fill in your code here


        // delay after commutator
        // fill in your code here


    // butterfly radix calculation with twiddle factor
    // Y0 = A + B
    // Y1 = (A - B)*W
    // instantiate your bf_radix2.v here
    // fill in your code here


//layer 3
    // twiddle factor MUX, depends on twiddle_sel3, to select twiddle factors for the 3rd layer of the 64IFFT pipeline
    // input: 512 bits, twiddle_lut_re, twiddle_lut_im
    // output: 16 bits, twiddle3_re, twiddle3_im
    // fill in your code here


    //re-arrange data
        // delay before commutator
        // fill in your code here


        // commutator
        // fill in your code here


        // delay after commutator
        // fill in your code here


    // butterfly radix calculation with twiddle factor
    // Y0 = A + B
    // Y1 = (A - B)*W
    // instantiate your bf_radix2.v here
    // fill in your code here


//layer 4
    // twiddle factor MUX, depends on twiddle_sel4, to select twiddle factors for the 4th layer of the 64IFFT pipeline
    // input: 512 bits, twiddle_lut_re, twiddle_lut_im
    // output: 16 bits, twiddle4_re, twiddle4_im
    // fill in your code here


    //re-arrange data
        // delay before commutator
        // fill in your code here


        // commutator
        // fill in your code here


        // delay after commutator
        // fill in your code here


    // butterfly radix calculation with twiddle factor
    // Y0 = A + B
    // Y1 = (A - B)*W
    // instantiate your bf_radix2.v here
    // fill in your code here


//layer 5
    // twiddle factor MUX, depends on twiddle_sel5, to select twiddle factors for the 5th layer of the 64IFFT pipeline
    // input: 512 bits, twiddle_lut_re, twiddle_lut_im
    // output: 16 bits, twiddle5_re, twiddle5_im
    // fill in your code here


    //re-arrange data
        // delay before commutator
        // fill in your code here


        // commutator
        // fill in your code here


        // delay after commutator
        // fill in your code here


    // butterfly radix calculation with twiddle factor
    // Y0 = A + B
    // Y1 = (A - B)*W
    // instantiate your bf_radix2.v here
    // fill in your code here


//layer 6
    //re-arrange data
        // delay before commutator
        // fill in your code here


        // commutator
        // fill in your code here


        // delay after commutator
        // fill in your code here


    // butterfly radix calculation without twiddle factor
    // Y0 = A + B
    // Y1 = A - B
    // instantiate your bf_radix2_noW.v here
    // fill in your code here



endmodule
