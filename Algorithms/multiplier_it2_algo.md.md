#Iteration 2 of Floating point Multiplier 

In previous iteration i was able to implement the basic multiplier which was able to show accurate results for general cases.
Also in output and waveform section of iteration 1 multiplier it was observed that - Iteration 1 does not have any round off algorithms , does not handle edge cases such as Nan , zero or infinite values. Also lacks any support if Denormal (exponent=0) value appears or Overflow occurs. All these issues were also faced after completion of Adder it1, so i already have explained in detail how ill optimize for these exceptions.

Required Improvements-
1. First the edge cases- 4types(Nan, infinity, Denormal, zero) A. Infinity = exponent=FF and fraction=0   B. Nan = exponent=FF and fraction not equal to zero C. Denormal = exponent=0 and fraction is not equal to zero. (for denormal numbers the convention is 0.{fraction} and not 1.{fraction} so we will need to create a separate case for adding this significant bit)
D. Zero - exponent=0 and fraction =0 Ill start by detecting these cases if they are present. 

2. If they are present ill handle them in the following manner- a. infinity+ infinity =infinity b. Zero+ operand= operand c. Infinity-infinity = Nan ( i do not have any verification if this is how are computers actually handle it, but seems logical enough to me) d. if any operand is Nan result=Nan (verified from Hennessy computer organization textbook) {same as what i followed for second iteration of Adder module}

3. Now to begin with multiplication 
```
      1.{23 bits}
  ×   1.{23 bits}
   ---------------
     num.{46 bits}=product[47:0] // as 24 bits * 24 bits so answer can be 48 bits at most. Therefore num can be 1 or 2bits. {01,10,11}, notice=00 is not possible 
```

After this we just compare msb of product, msb=0  so here num ={01} then , exponents sum = expA + expB-127(removing twice added bias) and fraction = product[45:23]

But if num ={10 or 11} then msb =1; in this case exponents sum = expA + expB+ 1 -127 ; fraction = product[46:22]

4. after 3rd step it is sure that we have our final exponent. But now we need to take care of rounding part so for this we will consider 
```
significant= product[46:22] if MSB of product=0; here product[46]= leading 1, and fraction=product[45:23], and product[22] considered for round off
significant= product[47:23] if MSB of product=1; here product[47]= leading 1, and fraction=product[46:24], and product[23] considered for round off
```
so we will consider 25 bits in significant this way.

5.Now recall the round, sticky and guard bit that i found on IEEE754 rounding convention (https://ee.usc.edu/~redekopp/cs356/slides/CS356Unit3_FP.pdf  ; credits to the university for providing on their website} ill again follow the same convention.
ill again document how it works - (according to IEEE standards)
We round off if we are more than half way or exactly at half to the next representation.
to do so Standard defines guard bit as last 2nd msb, which we will keep as it is. round- the lsb bit and sticky bit is or of all remaining bits of fraction.
so if guard bit is 0; nothing to round off just truncate.
if guard bit is 1 check for both round and sticky bit if both are 1 then we round off.{notice: this ensures that it will round off to next even; i dont know why we are skipping odd but this is the standard as mentioned}  

6. Once this is done ; we will check for overflow ; if overflow again add 1 to the exponent sum and shift fraction right discarding the lsb.
if no overflow - do nothing.

7. calculate sign bit as = operand_A[31]*operand_B[31]

8.Take care of all the special cases as mentioned in step1.


This completes the  Ieee 754 Multiplier algorithm for iteration 2, i think it should be able to handle every possible case. 
 
