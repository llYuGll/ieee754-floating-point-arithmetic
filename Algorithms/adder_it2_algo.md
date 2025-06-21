#2nd iteration of IEEE754 adder algorithm

The first iteration worked well, but in this iteration ill try to remove the challenges that the simulation faced in 1st algorithm. I have taken a lot of gap time to prepare this algorithm, so ill try to make every change required to make it completely error free and robust. I have gone through many sources which discuss how to round off in IEEE754 convention.
so that in next iteration of adder(hopefully the last) i can concentrate on complex issues like pipelining. 

**Observations from it_1**
1.Covers general cases but edge cases will need special treatments.(NaN, infinity, Denormal, zero)
2.the logic implements addition but not subtraction.
3.No overflow/underflow logic implemented, what if exponent can not be represented using 8 bits? etc 
4.Rounding off algorithm needs to be defined because the last digit of output and expected result miss by 1 bit on 23rd fractional place this is bound to happen unless a logic is created.


**Improvement-**
1.First the edge cases- 4types(NaN, infinity, Denormal, zero)
-Infinity = exponent=FF and fraction=0
-Nan      = exponent=FF and fraction not equal to zero
-Denormal = exponent=0 and fraction is not equal to zero. (for denormal numbers the convention is 0.{fraction} and not 1.{fraction} so we will need to create a separate case for adding this significant bit)

In next code ill first make separate wires to identify if any of the edge cases are found and handle them separately. For their handling ill use the following rules-
a. infinity+ infinity =infinity
b. Zero+ operand= operand
c. Infinity-infinity = Nan  ( i do not have any verification if this is how are computers actually handle it, but seems logical enough to me)
d. if any operand is Nan result=Nan (verified from Hennessy computer organization textbook) 

2.Now for subtraction logic, we need to may need to shift left or right for normalization(unlike previous code) so my next code will contain a separate function which will generate number of leading zeroes in the result of subtraction. Also ill use this logic--> (sign1==sign2) addition , if not then subtraction and sign of bigger operand.


3. For overflow and underflow , ill define a temporary wires which will contain some extra bits , if this bits turn one ill consider overflow, for underflow ill check the exponent of result after normalization if zero ill consider it denormal.

**4.** Rounding off is bit tricky , *I could not come up with any logic myself* hence from some of the open sources i stole this very beautiful concept- 
a. Guard bit-First extra bit to the right of mantissa
b. Round bit-Next bit to the right of the guard bit
c. Sticky bit-Logical OR of all bits to the right of round
If any of the bits shifted out are 1, the sticky bit is set to 1.If all removed bits are 0 then sticky bit remains 0. *Ill directly incorporate this stolen logic(because it follows IEEE 754 standards) into my code. (thanks to opensource)* 


I think all the short comings of iteration 1 will be solved with this newer code.  

![image](https://github.com/user-attachments/assets/a3840d99-45d3-4478-b64d-fb37654efdef)
![image](https://github.com/user-attachments/assets/9403d0b7-b6f3-47a1-af68-951d9f6c2087)



 

![Diagram2](../images/diagram.png)
