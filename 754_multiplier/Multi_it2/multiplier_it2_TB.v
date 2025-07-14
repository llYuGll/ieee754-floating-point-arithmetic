module multiplier_it2_TB;

	// Inputs
	reg [31:0] a;
	reg [31:0] b;

	// Outputs
	wire [31:0] result;

	// Instantiate the Unit Under Test (UUT)
	multiplier_it2 uut (
		.a(a), 
		.b(b), 
		.result(result)
	);

	initial begin
	// Initialize Inputs
	a = 0;b = 0;#10
	//  2.0 * 3.0 = 6.0
	a = 32'h40000000; b = 32'h40400000; #10;

	//  -2.0 * 3.0 = -6.0
	a = 32'hC0000000; b = 32'h40400000; #10; 

	// 0.0 * 5.0 = 0.0
	a = 32'h00000000; b = 32'h40A00000; #10; 
// Infinity * 2.0 = Infinity
	a = 32'h7F800000; b = 32'h40000000; #10; 

	// -Infinity * -3.0 = +Infinity
	a = 32'hFF800000; b = 32'hC0400000;#10; 
	//  NaN * 1.0 = NaN
	a = 32'h7FC00000; b = 32'h3F800000; #10; 
	//2.0 * NaN = NaN
	a = 32'h40000000; // 2.0
	b = 32'h7FC00000; // NaN
	#10;

	// 0 * Infinity = NaN
	a = 32'h00000000; b = 32'h7F800000; #10; 
	//  Denormal * 2.0
	a = 32'h00000001; // denormal
	b = 32'h40000000; #10; 
// above test cases were all covered  in algorithm to check all edge case
// now some random numbers 
//2,24*2.14=4.7936
a = 32'b01000000000011110101110000101001; b = 32'b01000000000010001111010111000011; #10;
//3.87*7.21=27.9027=01000001110111110011100010111011
a = 32'b01000000011101111010111000010100; b = 32'b01000000111001101011100001010010; #10;
//24789*224=5,552,736= 01001010101010010111010011000000
a = 32'b01000110110000100101111000000000; b = 32'b01000011011000000000000000000000; #10;
//5,552,736*5,552,736= 30,832,877,085,696=01010101111000000101011010110101
a = 32'b01001010101010010111010011000000; b = 32'b01001010101010010111010011000000; #10;


	end
initial begin
$monitor ("%0d: %0h * %0h = %b", $time, a,b,result);end
endmodule

