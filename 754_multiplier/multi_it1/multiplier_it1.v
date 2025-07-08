module fp_multiplier (
    input  [31:0] a, // Operand- A
    input  [31:0] b, // Operand -B
    output [31:0] result
);
//This is the first iteration of 754 multiplier, i am keeping comments explaination to minimun, for more detailed understanding
// of the algorithm please see my multipler_iter1 file in  Algorithm folder.
    //separate out fields
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] frac_a = a[22:0];
    wire [22:0] frac_b = b[22:0];

    //Add hidden leading 1 in fractions for normalized numbers
    wire [23:0] mant_a ={1'b1, frac_a};
    wire [23:0] mant_b ={1'b1, frac_b};

    //Multiply significands (24x24 = 48 bits)
    wire [47:0] mant_prod =mant_a * mant_b;

    // Exponent calculation
    wire [8:0] exp_sum = exp_a + exp_b - 8'd127;// we are adding bias 2 times due to exp_a and exp_b so we need to subtract once

    // Normalization
    wire msb = mant_prod[47];
    wire [7:0] exp_norm = msb ?(exp_sum + 1'b1):exp_sum;
    wire [22:0] frac_norm = msb ? mant_prod[46:24] : mant_prod[45:23];

    // Sign calculation
    wire sign_res = sign_a ^ sign_b;

    // final output
    assign result = {sign_res, exp_norm[7:0], frac_norm};

endmodule
