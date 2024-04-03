////////////////////////////////////////////////////////////////
// input ports
// A_re    -the 1st input (real part) of the radix butterfly unit (16 bits)
// B_re    -the 2nd input (real part) of the radix butterfly unit (16 bits)
// W_re    -the twiddle factor (real part) (16 bits)
// A_im    -the 1st input (imag part) of the radix butterfly unit (16 bits)
// B_im    -the 2nd input (imag part) of the radix butterfly unit (16 bits)
// W_im    -the twiddle factor (imag part) (16 bits)

// output ports
// Y0_re    -the 1st output (real part) of the radix butterfly unit (16 bits)
// Y1_re    -the 2nd output (real part) of the radix butterfly unit (16 bits)
// Y0_im    -the 1st output (imag part) of the radix butterfly unit (16 bits)
// Y1_im    -the 2nd output (imag part) of the radix butterfly unit (16 bits)
////////////////////////////////////////////////////////////////
module bf_radix2
    (
        input signed [15:0] A_re,
        input signed [15:0] B_re,
        input signed [15:0] W_re,
        input signed [15:0] A_im,
        input signed [15:0] B_im,
        input signed [15:0] W_im,
        output signed [15:0] Y0_re,
        output signed [15:0] Y1_re,
        output signed [15:0] Y0_im,
        output signed [15:0] Y1_im
    );

    // Wire definitions
    wire signed [15:0] sum_re;
    wire signed [15:0] sum_im;

    wire signed [15:0] diff_re;
    wire signed [15:0] diff_im;

    wire signed [15:0] prod_re;
    wire signed [15:0] prod_im;

    wire signed [15:0] prod_re_re;    
    wire signed [15:0] prod_re_im;
    wire signed [15:0] prod_im_re;    
    wire signed [15:0] prod_im_im;
    // Adder and subtractor
    assign sum_re = A_re + B_re;
    assign diff_re = A_re - B_re;
    assign sum_im = A_im + B_im;
    assign diff_im = A_im - B_im;

    assign Y0_im = sum_im;
    assign Y0_re = sum_re;

    // Multiplier for Y1_re and Y1_im
    // prod_re = diff_re * W_re - diff_im * W_im;
    // prod_im = diff_re * W_im + diff_im * W_re;

    // prod_re_re = signed_mult(diff_re, W_re);
    multiplier_signed A(
        .a(diff_re),       // Connect input_a to submodule input a
        .b(W_re),       // Connect input_b to submodule input b
        .result(prod_re_re)  // Connect submodule result to output_result
    );
    // prod_re_im = signed_mult(diff_im, W_im);
    multiplier_signed B(
        .a(diff_im),       // Connect input_a to submodule input a
        .b(W_im),       // Connect input_b to submodule input b
        .result(prod_re_im)  // Connect submodule result to output_result
    );
    // prod_im_re = signed_mult(diff_re, W_im);
    multiplier_signed C(
        .a(diff_re),       // Connect input_a to submodule input a
        .b(W_im),       // Connect input_b to submodule input b
        .result(prod_im_re)  // Connect submodule result to output_result
    );
    // prod_im_re = signed_mult(diff_im, W_re);
    multiplier_signed D(
        .a(diff_im),       // Connect input_a to submodule input a
        .b(W_re),       // Connect input_b to submodule input b
        .result(prod_im_im)  // Connect submodule result to output_result
    );


    // prod_re = diff_re * W_re - diff_im * W_im;
    // prod_im = diff_re * W_im + diff_im * W_re;

    assign prod_re = prod_re_re - prod_re_im;
    assign prod_im = prod_im_re + prod_im_im;

    assign Y1_re = prod_re;
    assign Y1_im = prod_im;

endmodule



// instantiate submodule in verilog

