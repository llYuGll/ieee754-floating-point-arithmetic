# IEEE 754 Floating-Point Arithmetic

## Overview

This repository contains **documentation**, **algorithms**, and **Verilog implementation** of IEEE 754 floating-point arithmetic.  
I am a student exploring digital design, computer architecture, and other cool stuff!  
So I’ll start with basic algorithms and some basic-level Verilog code for real number arithmetic in computers.  
I’ll eventually modify my own code in further iterations to improve efficiency and data handling.  
I’ll learn and grow along with this repo! So my initial implementations or algorithms might contain some bugs.  
I am open to suggestions!

My plan is to start with a very basic floating-point adder and keep on iterating it to reach maximum efficiency level where it can handle all edge cases and work optimally!

---

## Contents

**Documentation:**  
- Overview of IEEE 754 floating-point standard.  
- Representation of floating-point numbers (sign, exponent, significand).  
- Special values: zero, infinity, NaN, subnormal numbers.  
- Rounding modes and exceptions.  

**Algorithms:**  
- Conversion between binary and decimal floating-point numbers.  
- Floating-point addition, subtraction, multiplication, and division algorithms.  

**Hardware Implementations:**  
- Verilog modules for floating-point arithmetic operations (addition, subtraction, etc.).  
- Testbenches for verification against software results.  

**Examples:**  
- Sample code for conversion and arithmetic in various programming languages. (eventually)  
- Worked examples and edge cases.  

## Contributing

Contributions are welcome! If you find bugs, have suggestions, or want to improve the code, please open an issue or submit a pull request.

## Repository Structure
```
IEEE754-floating-point/
├── docs/ # Documentation and explanations of IEEE 754 standards
├── verilog/ # Verilog hardware designs and testbenches for different circuits
├── algorithms/ # basic idea behind writing the code or making any new changes will be here
├── scripts/ # Conversion and arithmetic scripts   (will add at later stages)
├── examples/ # Worked examples 
└── README.md 
```
**Note**
Adder_it1_algo is algorithm behind Adder_it1.v verilog design. (ill stick to this kind of writing style).