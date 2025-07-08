#Iteration 1 of Floating point multiplier

Lets consider 2 numbers that we need to multiply , (1.110 × 10^10 )× (9.200 × 10^-5) in decimal, assuming they are already normalized for exponent we can just add exponents of both= 10+(-5)=5; and for  remaining fraction we can multiply bit by bit
``` 
    1.110
×   9.200
----------
      0000
     0000
    2220
+  9990
----------
 10212000
```
by looking at the fraction bits for us its number will be fixed so we already know where decimal point is- 10.212
so the final answer= (10.212 * 10^5 ) but this is not normalized - to normalize= 1.021*10^6; for sign bit +*+=+; -*+=- ; -*-=+ i.e same sign give + and different sign give - 


now we need to do the same for binary multiplication-

before that id like you to recall the 32 bit single precision format-
{1-bit sign (s) , 7 bit for exponent(E) , 24 bit for fraction } and it equates to *(-1)^S × (1 + Fraction) × 2(E - Bias)* for us bias = 127;

we will handle with edge cases and other complex rounding cases etc in upcoming iterations. For now focus is on creating a working 754 multiplier module.

Lets start with algorithm-

1.Start by separating sign bit , exponents and fractions of both operands and save in wires of respective lengths. 
2.To calculate exponent of final answer, *expo_final=(expo_A + expo_B -127)*
3.Now for multiplication of significants lets start by deciding the variable size
 operand A = 1.{12 bit fraction} // first 12 bits
 operand B = 1.{12 bit fraction}
A*B = 1.{12 bits} * 1.{12 bits} = 
```
=     1.{12 bits}
  ×   1.{12 bits}
   ---------------
     num.{24 bits} // as 13 bits * 13bits so answer can be 26 bit at most. Therefore num can be 1 or 2bits. 
```
4. Now check for normalization , to do so we can check num wire ( we will initialize it to 00 ) if num[msb]==1 we need to normalize by adding 1 to the exponent and shift the 24 bit fractional answer by 1 bit, now the new msb of fractional part will be num[LSB].

5.Finally give out the result as {final sign , exponent , fraction }


This is the basic code that  I am going to implement in 1st iteration of  754 multiplier, I know that it has lot of gray areas- such as Nan, infinite values, edge cases and it lacks any proper round off, ill try to work on these issues and any other issues that might come up.


