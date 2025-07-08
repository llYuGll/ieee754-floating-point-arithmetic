
module tb_fp_multiplier;

    reg [31:0] a, b;
    wire [31:0] result;

    // Instantiate 
    fp_multiplier uut (
        .a(a),
        .b(b),
        .result(result)
    );
   initial
        begin
            $monitor("A = %h, B = %h, Result = %h", a, b, result); end

    initial begin
        // Test 1: 1.5 * 2.5 = 3.75
        a = 32'b00111111110000000000000000000000; // 1.5 in IEEE 754
        b = 32'b01000000001000000000000000000000; // 2.5 in IEEE 754
        #10; //result 0x40600000=  01000000011100000000000000000000

        // Test 2: -1.25 * 4 = -5.0
        a = 32'hBFA00000; // -1.25 in IEEE 754
        b = 32'h40800000; // 4.0 in IEEE 754
        #10;// result= 0xC0A00000

        // Test 3: 0.75 * 0.5 = 0.375
        a = 32'h3F400000; // 0.75 in IEEE 754
        b = 32'h3F000000; // 0.5 in IEEE 754
        #10;// result= 0x3EC00000

        // Test 4: -3.0 * -2.0 = 6.0
        a = 32'hC0400000; // -3.0 in IEEE 754
        b = 32'hC0000000; // -2.0 in IEEE 754
        #10;
       // result =0x40C00000

        $finish;
    end

endmodule
