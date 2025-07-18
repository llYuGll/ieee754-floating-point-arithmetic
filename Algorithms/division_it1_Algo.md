#Iteration 1 Division Algorithm

For me the division in binary is a topic that i haven't given much thought on previously, so rather than starting directly with floating point division algorithm I am staring with normal binary division which ill eventually try and convert into IEEE 754 division algorithm.

So for the 1st iteration ill start with basic division circuit which can handle 32 bit binary operands , the algorithm will also try to handle signed division operations. I went through some theory of faster division circuits using remainder prediction at each step by using look up tables. These algorithms will require some kind of memory circuits, for now i have decided to start with simple intuitive algorithm , which follow basic elementary long division approach. 

Consider an example-

```
        10001                           clearly dividend= (quotient*divisor)+remainder. 
      _______________                           10001010= (10001*1000)+10  = 10001010          --> true
1000 |  10001010
        1000
       _______                                
        00001
        #0000
       _______
        000010
        ##0000
       _______
        0000101
        ###0000
       _________
       000001010
       #####1000
       __________
       000000010

```
Here I just followed normal long division , for binary quotient at each stage will be either 0 or 1, so makes it easy. One more thing to notice is that at each stage we actually subtract from one shifted place. For better understanding lets take a 4 bit example   7 divide by 2.  i.e.. (0000_0111) divide by (0010)
```
        00011                    clearly dividend= (quotient*divisor)+remainder. 
      _______________                           0000_0111= (0010*00011)+0000_0001           --> true
0010 |  0000_0111                                    7 = (2*3)+ 1
        0000
       _______                                
        0000_0
        #0000
       _______
        0000_01
        ##0000
       ________
        0000_011
        ###0_010
       _________
        0000_0011
        ####_0010
      ____________
        0000_0001

```
So now ill turn this into an algorithm, first thing to note dividend should have double number than standard bits, so for 32 bits operation dividend will have 64 bits.
Also for previous example we required 5 cycles of subtractions , so for 32 bits we will need 33 bits.

In reality what the algorithm is doing is it will try to remove divisor from dividend , if possible quotient gets a 1 shifted in it, if no then 0. At every stage the divisor is shifted left before using it for subtraction.( to match the dividend.)

**ALGORITHM**   

1. Start by declaring a 64 bit register with 32 upper bits as divisor. so Divisor= (upper 32 bits=divisor; lower 32 bits=32'b0).
2. Define quotient as 32bits initialized to 32'b0; and remainder reg of 64 bits with lower 32 bits filled as dividend.
3. It is clearly visible why it is being done looking at previous example. So divisor=(32'b*divisor*;32'b0) ; remainder=(32'b0,divident) ; quotient =32'b0.
4. Now ill re do the previous example and create its generalized algorithm(ill stick with 4 bits for the example to make it more simpler) . so divisor=(0010_0000) remainder=(0000_0111)
and quotent=(0000)
5.Now  remainder= remainder - divisor = (0000_0111)-(0010_0000) ------> clearly as divisor> remainder this will give negative output, we can check for MSB==1 if true then we readd the divisor in remainder to get back original remainder. Upon doing this we will shift quotent reg left by adding 0 at left most position.
Now keep on repeating it - for 5 iteration in this example. (33 for 32 bit operation). If after remainder=remainder-divisor , remainder[MSB]==0 it means divisor<= remainder so shift quotent left by adding 1 at LSB.
6. after repeating for 33 times we will have quotent and remainder.  


7.Now ill also add support for signed divison.
Example=
```
-7/2 --> quotient= -3    remainder =-(quotent*divisor)+divident=-1
7/-2 --> quotient= -3    remainder =-(quotent*divisor)+divident=+1
-7/-2 --> quotient= 3    remainder =-(quotent*divisor)+divident=-1
```
so the logic is sign of remainder is + if sign of quotient and divisor are same , while - if they are different.
For the sign of remainder is equal to that of divident.

8.So for 32 bits operation we will have sign bit at MSB , and we will in reality perform operation only on 31 bits. But for simplicity we will still use 32 bits but keep MSB 0, while performing the operation and then later change it according to the sign logic discussed above. 
9. One exception can occur if divisor is 0, for now ill just prevent this case , but in later iteration ill think of something concrete like Interupt service routine.


This wil be the 1st iteration code for Divion , again this is just normal division and not IEEE754 floating point, ill eventually upgrade it. (here ofcourse i assumed that adder and subtractor circuits are already present.)
   