module multiplier_it2 (
 input  [31:0] a, // Operand- A
 input  [31:0] b, // Operand -B
 output reg [31:0] result
);
//This is the 2nd iteration of 754 multiplier, Again i have explained this algorithm in great details in ALGORITHM section ,
// ill try to add only essential comments plz refer to algorithm section for complete explanation

//starting with separating each field as in 1st iteration
 wire sign_a = a[31];
 wire sign_b = b[31];
 wire [7:0] exp_a = a[30:23];
 wire [7:0] exp_b = b[30:23];
 wire [22:0] frac_a = a[22:0];
 wire [22:0] frac_b = b[22:0];
 
 // Sign calculation 
 wire sign_res = sign_a ^ sign_b;
 
// This part is new , here we will detect any edge case if it occures
 wire a_is_zero =(exp_a == 8'b0) &&(frac_a == 23'b0);
 wire b_is_zero =(exp_b == 8'b0) &&(frac_b == 23'b0);
 wire a_is_inf  =(exp_a == 8'hFF) &&(frac_a == 23'b0);
 wire b_is_inf  =(exp_b == 8'hFF) &&(frac_b == 23'b0);
 wire a_is_nan  =(exp_a == 8'hFF)&&(frac_a != 23'b0);
 wire b_is_nan  =(exp_b == 8'hFF)&& (frac_b != 23'b0);


 //Add  leading 1 in fractions for normalized numbers
 wire [23:0]significant_a = (exp_a == 8'b0)? {1'b0, frac_a}:{1'b1,frac_a};
 wire [23:0]significant_b = (exp_b == 8'b0)? {1'b0, frac_b}:{1'b1,frac_b};

 //Multiply as explained we will need 48 bits to store the product
 wire [47:0] significant_prod = significant_a *significant_b;

 // Exponent calculation
 wire [8:0] exp_sum = exp_a + exp_b - 8'd127; // we need to remove extra bias becaues we already added 2 biased numbers

 // Now to normalize as given in Algorithm
 wire msb =significant_prod[47];
 wire [7:0]exp_norm = msb ?(exp_sum + 1'b1) :exp_sum[7:0];
 wire [24:0]significant_norm = msb ?significant_prod[47:23] :significant_prod[46:22];
// notice this signficant_norm contains leading 1 as well as extra bit for rounding algorithm, please refer algorithm for more explaination
// Rounding logic
 wire guard = significant_norm[1];
 wire round = significant_norm[0];
 wire sticky = |significant_prod[21:0];
 wire round_up = guard &&(round ||sticky ||significant_norm[2]);
 wire [23:0] significant_rounded = significant_norm[24:1] + round_up;
 wire significant_overflow = significant_rounded[23];// if MSB ==1 it means there was an overflow, we require only 23 bits but to avoid overflow
 // we again need to shift and increment exponent
 // Exponent after rounding
 wire [7:0]exp_final =significant_overflow ?(exp_norm + 1'b1) :exp_norm;
 wire [22:0]frac_final =significant_overflow ?significant_rounded[23:1] :significant_rounded[22:0];

 // lets take care of these special cases first as explained in algorithm  
 always @(*) begin
 // nan. as explained nan when either value is nan, or one is infinite other is zero
	  if (a_is_nan ||b_is_nan ||(a_is_inf &&b_is_zero) || (a_is_zero &&b_is_inf)) begin
			result = {1'b0,8'hFF,23'h444400};end// some random Nan
	  // Infinity when either is finite but other should not be zero, but that case is already covered so only chek for infinity
 else if (a_is_inf||b_is_inf) begin
			result = {sign_res, 8'hFF, 23'b0}; end
	  // Zero - if any one is zero answer is zero
	  else if(a_is_zero || b_is_zero) begin result = {sign_res, 31'b0}; end
// denormal numbers- check for overflow and underflow(when exponent is zero) 
	  else begin
	  if (exp_final >= 8'hFF) begin
	  result = {sign_res, 8'hFF, 23'b0}; // Infinity
	  end
// Underflow, needs a 0 at expo 
	else if (exp_final == 8'b0)begin 
	result = {sign_res, 8'b0, frac_final};
	end
// normal result	
			else begin
				 result = {sign_res, exp_final, frac_final};
end
 end
 end
endmodule

