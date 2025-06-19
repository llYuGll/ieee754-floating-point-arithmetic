module adder_it1(
    input [31:0] op1,
    input [31:0] op2,
    output reg [31:0] result
);

wire[7:0] exp1=op1[30:23];
wire[7:0] exp2=op2[30:23];
wire[23:0] sig1={1'b1,op1[22:0]}; //I have made an update regarding this in algo
wire[23:0] sig2={1'b1,op2[22:0]};
reg[7:0] exp_diff;
reg[23:0] shifted_sig,nomliz_sig,larger_sig; 
reg[7:0] final_exp;
wire[24:0] sum;
//rem the algo we only play with smaller operand, make it directly addable to larger one
assign sum = larger_sig +shifted_sig;
always @(*) begin
if (exp1 >= exp2) begin
   exp_diff = exp1 - exp2;
   shifted_sig = sig2 >> exp_diff;
   larger_sig = sig1;final_exp = exp1;
    end else begin
 exp_diff = exp2 - exp1;
 shifted_sig = sig1 >> exp_diff;
 larger_sig = sig2;
 final_exp = exp2;
    end
// this can result in two cases A)if carry occures then shift right by 1 to normalize
// if no carry then no need to shoft already normalized
if(sum[24]) begin
        nomliz_sig = sum[24:1];     
        final_exp = final_exp + 1;  // update expo
    end else begin
        nomliz_sig = sum[23:0];
    
    end
	//last step 
    result = {1'b0,final_exp,nomliz_sig[22:0]};
end

endmodule
