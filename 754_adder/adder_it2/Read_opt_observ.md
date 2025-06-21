#Outputs
Finished circuit initialization process.
```
0 :A=00000000, B=00000000 , output=00000000
10 :A=40400000, B=40800000 , output=41400000
20 :A=40800000, B=40400000 , output=41400000
30 :A=3f800001, B=3f800000 , output=3f800004
40 :A=7f7fffff, B=7f7fffff , output=7f800000
50 :A=00000000, B=40400000 , output=40400000
60 :A=7f800000, B=40400000 , output=7f800000
70 :A=7fc00000, B=40400000 , output=7fc00000
80 :A=00000001, B=00000001 , output=00800008
90 :A=3f800000, B=3f7fffff , output=407fffff
100 :A=40400000, B=c0000000 , output=40000000
110 :A=3f800000, B=33000000 , output=40000000
120 :A=00800000, B=80800000 , output=00000000
-----------------------------------------------
```

**Analysis**

time 30: slightly off in rounding to nearest
time 110: again some issue with rounding off. (expected answer was 1 not 2)

**Observations**
1. Lot of changes from previous iteration, almost works for any cases
2. Although i copied the rounding off logic from opensource, it is still not appropriate. and can be improved
ill try adding my own logic in next iteration.
3.Next aim is to add pipelining logic. and start with multiplier circuit.