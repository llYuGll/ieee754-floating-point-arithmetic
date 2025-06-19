# IEEE 754 Floating-Point Arithmetic

## Overview

This repository contains **documentation**, **algorithms**,**Verilog implementation** and **RTL synthesis** of IEEE 754 floating-point arithmetic.  
I’ll start with basic algorithms and some basic-level Verilog code for real number arithmetic in computers.  
I’ll eventually modify my own code in further iterations to improve efficiency and data handling.  
I’ll learn and grow along with this repo! So my initial implementations or algorithms might contain some bugs.  
I am open to suggestions!

My plan is to start with a very basic floating-point adder and keep on iterating it to reach maximum efficiency level where it can handle all edge cases and work optimally!

---

## Contents
**Algorithms:**  
- File will contain logical.txt files for each iteration of unit. For example - Adder_it1, Adder_it2, Multiplier_it1 and so on.
- With each iteration logic ill try to evolve the logic to perform better and more complete than previous one.

**Hardware Implementations:**  
- Repository will contain separate file for each unit. For example- IEEE_754_adder,IEEE_754_multiplier etc
- Subsiquently Each sub file will contain further iterations, example- Adder_it1 folder
- Finally this iteration folder will contain all the required files.( RTL synthesis , verilog code, Test_benche, Output, improvement.txt etc

## Repository Structure
```
IEEE754-floating-point/
├── docs/ # Documentation and explanations of IEEE 754 standards
├── algorithms/ # basic idea behind writing the code or making any new changes will be here
├── IEEE_754_adder,IEEE_754_multiplier....
      ├── Adder_it1, Adder_it2.....
            ├── RTL_synthesis,Verilog code ......
└── README.md 
```

**Examples:**  
- Sample code for conversion and arithmetic in various programming languages. (eventually)  
- Worked examples and edge cases.  

## Contributing

Contributions are welcome! If you find bugs, have suggestions, or want to improve the code, please open an issue or submit a pull request.


**Note**
Adder_it1_algo is algorithm behind Adder_it1.v verilog design. (ill stick to this kind of writing style).
