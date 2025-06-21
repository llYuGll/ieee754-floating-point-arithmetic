module adder_it2(
    input [31:0] op1,
    input [31:0] op2,
    output reg [31:0] result
    );
  // separate each part from operands
    wire sign1 = op1[31];
    wire sign2 = op2[31];
    wire [7:0] exp1 = op1[30:23];
    wire [7:0] exp2 = op2[30:23];
    wire [22:0] frac1 = op1[22:0];
    wire [22:0] frac2 = op2[22:0];
    
    // all temporary variables, i have added them at one place rather than declaring them instantly
    reg [7:0] exp_diff;
    reg [23:0] larger_sig, smaller_sig;
    reg [7:0] larger_exp;
    reg larger_sign, smaller_sign;
    reg effective_op; // 0 for addition, 1 for subtraction
    reg [26:0] shifted_sig; // Extra bits for guard, round, sticky as stolen and confessed in algorithm
    reg [26:0] sum_temp;
    reg [24:0] normalized_sig;
    reg [7:0] final_exp;
    reg final_sign;
    reg guard, round, sticky;
    reg [4:0] lz_count;

    // now lets consider all the 4 special cases, for more explanation i suggest going through algorithm_it2
    // from algorithm section
    wire zero1 = (op1[30:0] == 31'b0);
    wire zero2 = (op2[30:0] == 31'b0);
    wire inf1 = (exp1 == 8'hFF) && (frac1 == 23'b0);
    wire inf2 = (exp2 == 8'hFF) && (frac2 == 23'b0);
    wire nan1 = (exp1 == 8'hFF) && (frac1 != 23'b0);
    wire nan2 = (exp2 == 8'hFF) && (frac2 != 23'b0);
    wire denorm1 = (exp1 == 8'b0) && (frac1 != 23'b0);
    wire denorm2 = (exp2 == 8'b0) && (frac2 != 23'b0);

    // now adding a significant bit separately for addition also taking care of denorm number as explained in algorithm
    wire [23:0] sig1 = denorm1 ? {1'b0, frac1} : {1'b1, frac1}; // if denorm then 0.{fraction}
    wire [23:0] sig2 = denorm2 ? {1'b0, frac2} : {1'b1, frac2};
    wire [7:0] eff_exp1 = denorm1 ? 8'd1 : exp1;
    wire [7:0] eff_exp2 = denorm2 ? 8'd1 : exp2;

    // Count leading zeros function for normalization, could not find better way to do it than this, will update in next iteration
    // if i come across somthing easier
    function [4:0] count_leading_zeros;
        input [24:0] value;
        begin
            casex (value)
                25'b1xxxxxxxxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd0;
                25'b01xxxxxxxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd1;
                25'b001xxxxxxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd2;
                25'b0001xxxxxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd3;
                25'b00001xxxxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd4;
                25'b000001xxxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd5;
                25'b0000001xxxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd6;
                25'b00000001xxxxxxxxxxxxxxxxx: count_leading_zeros = 5'd7;
                25'b000000001xxxxxxxxxxxxxxxx: count_leading_zeros = 5'd8;
                25'b0000000001xxxxxxxxxxxxxxx: count_leading_zeros = 5'd9;
                25'b00000000001xxxxxxxxxxxxxx: count_leading_zeros = 5'd10;
                25'b000000000001xxxxxxxxxxxxx: count_leading_zeros = 5'd11;
                25'b0000000000001xxxxxxxxxxxx: count_leading_zeros = 5'd12;
                25'b00000000000001xxxxxxxxxxx: count_leading_zeros = 5'd13;
                25'b000000000000001xxxxxxxxxx: count_leading_zeros = 5'd14;
                25'b0000000000000001xxxxxxxxx: count_leading_zeros = 5'd15;
                25'b00000000000000001xxxxxxxx: count_leading_zeros = 5'd16;
                25'b000000000000000001xxxxxxx: count_leading_zeros = 5'd17;
                25'b0000000000000000001xxxxxx: count_leading_zeros = 5'd18;
                25'b00000000000000000001xxxxx: count_leading_zeros = 5'd19;
                25'b000000000000000000001xxxx: count_leading_zeros = 5'd20;
                25'b0000000000000000000001xxx: count_leading_zeros = 5'd21;
                25'b00000000000000000000001xx: count_leading_zeros = 5'd22;
                25'b000000000000000000000001x: count_leading_zeros = 5'd23;
                25'b0000000000000000000000001: count_leading_zeros = 5'd24;
                default: count_leading_zeros = 5'd25; // All zeros
            endcase
        end
    endfunction

    // Main logic, as said in algo ill separately handle each special case
    always @(*) begin
        if (nan1 || nan2) begin // if any of the operand is not defined
            result = {1'b0, 8'hFF, 23'h400000}; // as per convention
        end
        else if (inf1 && inf2) begin
            if (sign1 == sign2) begin
                result = {sign1, 8'hFF, 23'b0}; // Same sign infinities
            end else begin
                result = {1'b0, 8'hFF, 23'h400000}; // Inf - Inf = NaN
            end
        end
        else if (inf1) begin
            result = {sign1, 8'hFF, 23'b0}; // Preserve the sign of infinity
        end
        else if (inf2) begin
            result = {sign2, 8'hFF, 23'b0}; // Preserve the sign of infinity
        end
        else if (zero1 && zero2) begin
            result = {sign1, 31'b0}; // Both +0 or both -0
        end 
        else if (zero1) begin
            result = op2;
        end
        else if (zero2) begin
            result = op1;
        end
        else begin
            // adding or subtracting
            effective_op = sign1 ^ sign2; // 0 for addition  1 for subtraction
            
            // Determine larger operand by magnitude
            if (eff_exp1 > eff_exp2 || (eff_exp1 == eff_exp2 && sig1 >= sig2)) begin
                larger_sig = sig1;
                smaller_sig = sig2;
                larger_exp = eff_exp1;
                exp_diff = eff_exp1 - eff_exp2;
                larger_sign = sign1;
                smaller_sign = sign2;
            end else begin
                larger_sig = sig2;
                smaller_sig = sig1;
                larger_exp = eff_exp2;
                exp_diff = eff_exp2 - eff_exp1;
                larger_sign = sign2;
                smaller_sign = sign1;
            end
            
            // Alignment 
            if (exp_diff >= 8'd27) begin
                shifted_sig = 27'b0;
                sticky = |smaller_sig;
            end else begin
                shifted_sig = {smaller_sig, 3'b0} >> exp_diff;
                sticky = |({smaller_sig, 3'b0} & ((27'b1 << exp_diff) - 1));
            end
            
            if (!effective_op) begin
                sum_temp = {larger_sig, 3'b0} + shifted_sig;
                final_sign = larger_sign;
                
                if (sum_temp[26]) begin
                    normalized_sig = sum_temp[26:2];
                    final_exp = larger_exp + 1;
                    guard = sum_temp[1];
                    round = sum_temp[0];
                end else begin
                    normalized_sig = sum_temp[25:1];
                    final_exp = larger_exp;
                    guard = sum_temp[0];
                    round = sticky;
                end
                
                if (guard && (round || sticky || (normalized_sig[0] && normalized_sig[23:1] != 0))) begin
                    normalized_sig = normalized_sig + 1;
                    if (normalized_sig[24]) begin
                        normalized_sig = normalized_sig >> 1;
                        final_exp = final_exp + 1;
                    end
                end
                
                if (final_exp >= 8'hFF) begin
                    result = {final_sign, 8'hFF, 23'b0};
                end else begin
                    result = {final_sign, final_exp, normalized_sig[22:0]};
                end
            end else begin
                sum_temp = {larger_sig, 3'b0} - shifted_sig;
                if (sum_temp == 27'b0) begin
                    result = {1'b0, 31'b0};
                end else begin
                    final_sign = larger_sign;
                    lz_count = count_leading_zeros(sum_temp[25:1]);
                    if (lz_count >= larger_exp) begin
                        result = {final_sign, 31'b0};
                    end else begin
                        normalized_sig = sum_temp[25:1] << lz_count;
                        final_exp = larger_exp - lz_count;
                        guard = 1'b0;
                        round = 1'b0;
                        sticky = 1'b0;

                        if (guard && (round || sticky || (normalized_sig[0] && normalized_sig[23:1] != 0))) begin
                            normalized_sig = normalized_sig + 1;
                            if (normalized_sig[24]) begin
                                normalized_sig = normalized_sig >> 1;
                                final_exp = final_exp + 1;
                            end
                        end
                        
                        if (final_exp >= 8'hFF) begin
                            result = {final_sign, 8'hFF, 23'b0};
                        end else begin
                            result = {final_sign, final_exp, normalized_sig[22:0]};
                        end
                    end
                end
            end
        end
    end
endmodule
