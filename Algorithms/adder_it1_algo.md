#IEEE 754 adder circuit - first algorithm

Information about representation and other useful explanation is provided in Docs section of this repo.

For first try- i am thinking to keep it very basic. Ill assume that sign bit for overall number (MSB) is positive for both operands.(so MSB=0). Next this will not cover any edge cases or rounding off algorithms.

say
operand1= A[32]={sign_bit=0,8 bit exponent, 23 bit fraction}
operand2= B[32]={sign_bit=0,8 bit exponent, 23 bit fraction}

**Algorithm-**

STEP1 -Extract exponents of both operands, subtract them and decide which one is smaller and by how much.
allot smaller operand to C[32] and bigger to D[32]. And difference amount to new wire x.

STEP2- Using x , shift fraction of smaller number to right by x amount. and add 0 at vacated places at MSB
so previously fraction={old_23_bits} after this step new fraction={x-1 0's,1,23-x MSBs of old fraction}
// recall the extra 1 is due to the fact that Normalized form is 1.{fraction}

STEP3- in above step we have already matched the exponent of both operands so now we can directly add the fractional part. This addition is stored in 24 bits wire (y). (extra bit to ensure that carry if occurred is handled)
{STEP 3.5 if carry occures the answer of addition is= 10.{fraction 23 bits} *2^(expo of D) 
if no carry answer is= 1.{fraction 23 bits} *2^(expo of D)}

STEP4-now the normalization. current form= {1 or 10 ,23 bits of fraction}*2^(exponent of D)   //  exponent of bigger number. for normalization- check MSB of 24 bit fraction if equal to 1 --- already normalized.
if not shift left by 1 , then subtract 1 from current expo. again check if new 24th bit is 1 ---if not then continue this process, till 1 appears at 24th bit. when it does store the 23 later bits as z and the exponent as m.

STEP5- Now finally proper representation- final answer={sign(0),m(8bits_new expo),z(23 bits)}



*Example*
operand 1: (3.25)decimal=(11.01000000000000000000000)binary
operand 2: (0.75)decimal=(0.11000000000000000000000)binary

operand 1 normalized: 1.10100000000000000000000 *2^1
operand 2 normalized: 1.10000000000000000000000 *2^-1

operand 1 stored as= {0(sign),128(1+bias),10100000000000000000000(fraction)}
                   ={0_10000000_10100000000000000000000}

operand 2 stored as= {0(sign),126(bias-1),10000000000000000000000(fraction)}
                   = {0_01111110_10000000000000000000000}


now lets start with algorithm
STEP1-expo1=1; expo2=-1   x=(2); C=operand2; D=operand1
STEP2-new fraction of C= {0110000000000000000000}
STEP3-  y={binary addition of fraction of D and new fraction of C}
	 ={0110000000000000000000+10100000000000000000000}={1_00000000000000000000000)
carry generated= so new final number=10.00000000000000000000000 * 2^1(expo of D)
STEP4- Normalization -->1.000000000000000000000000 * 2^2(expo of D+1) shift right
STEP5 - representation = {0_(129)_000000000000000000000000}
			={0_10000001_000000000000000000000000}

Cleary this is 4.0 which is expected answer.
So this basic algorithm should be fine for first try! now ill try making Verilog module for the same.