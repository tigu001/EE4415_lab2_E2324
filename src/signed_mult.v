
module multiplier_signed(
    input signed [15:0] a, // 16-bit input a
    input signed [15:0] b, // 16-bit input b
    output signed [15:0] result // 16-bit output result
);

// wire [23:0] multi_result; // First 8 for integer, 16 for fractional part



wire signed [15:0] abs_a, abs_b; // absolute value of a and b
wire signed [15:0] pos_ab16, pos_a; // positive part of a*b - shortened
wire signed [23:0] pos_ab24; // positive part of a*b

assign abs_a = a[15]? -a:a;
assign abs_b = b[15]? -b:b;

assign pos_ab24 = abs_a * abs_b;
assign pos_ab16 = pos_ab24[23:8];

assign result = (a[15]^b[15])?-pos_ab16: pos_ab16;

endmodule
