module adder_it2_TB;

	// Inputs
	reg [31:0] op1;
	reg [31:0] op2;

	// Outputs
	wire [31:0] result;

	// Instantiate the Unit Under Test (UUT)
	adder_it2 uut (
		.op1(op1), 
		.op2(op2), 
		.result(result)
	);

	initial begin
		
		op1 = 0;
		op2 = 0;
#10;
op1=32'h40400000;op2=32'h40800000;//Addition: 3.0 + 4.0 = 7.0 
#10;
op1=32'h40800000;op2=32'h40400000;//Subtraction: 4.0 - 3.0 = 1.0" =32'41400000
#10;
op1=32'h3F800001;op2=32'h3F800000;//Small difference  left shift normalization

#10;
op1=32'h7F7FFFFF;op2=32'h7F7FFFFF;//overflow to infinity, 
#10;
op1=32'h00000000;op2=32'h40400000; //Zero + 3.0 
#10;
op1=32'h7F800000;op2=32'h40400000; //infinity+ 3.0 = infinty
#10;
op1=32'h7FC00000;op2=32'h40400000; //nan+ 3.0 = nan
#10;
op1=32'h00000001;op2=32'h00000001; //denoemal+denormal=32'h00000002
#10;
op1=32'h3F800000;op2=32'h3F7FFFFF;//32'h33800000 randomly checking some small nos
#10;
op1=32'h40400000;op2=32'hC0000000;
#10;
op1=32'h3F800000;op2=32'h33000000;
#10;
op1=32'h00800000;op2=32'h80800000;
	end
initial begin
$monitor("%0d :A=%h, B=%h , output=%h",$time,op1,op2,result);end	
	
      
endmodule

 
