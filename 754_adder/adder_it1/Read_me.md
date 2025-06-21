The first iteration worked well as planned, minute changes were made in algorithm itself for updated logic.

**Observations-**


1.the logic works well for addition but not subtraction.

2.Covers general cases but edge cases will need special treatments.

3.No overflow logic implemented, what if exponent can not be represented using 8 bits? etc

4.Rounding off algorithm needs to be defined because the last digit of output and expected result miss by 1 bit on 23rd fractional place this is bound to happen unless a logic is created.
