/*
In this problem, you will implement a mini-calculator, by filling out the missing parts of the modules below.
The top module is 'calculator'.

There are 3 inputs for the 'calculator' module: two 2-bit operands, and one 7-bit operator.
For example, in "3 + 2", "3" and "2" are operands, and "+" is operator.
There is only one 4-bit output called “result”, which prints out the calculation result from the inputs.
All operands and results represent numbers in unsigned form.

Operands are expected as an unsigned integer value, in binary form.
For example, input "01" means 1 in decimal form, and "11" means 1'd3. Following is an operand and result format.

------
|1||0| = 2 (in decimal form)    
------
 |  |__ operand[0]
 |_____ operand[1]

------------
|1||0||1||0| = 6 (in decimal form)    
------------
 |  |  |  |_ result[0]
 |  |  |____ result[1]
 |  |_______ result[2]
 |__________ result[3]

Output "result" is derived from the calculation from the inputs:

    "result" = "operand_a" "operator" "operand_b“

For example, for input ("2'b11", "-", "2'b10")=("operand_a", "operator", "operand_b"), "result" should print actual calculation result of "3 - 2", which is 1, in binary form.
Operators are one of following: "+, -, *, /", each representing addition, subtraction, multiplication, and division, respectively.
Following is the output rules for each operation.

    Addition: standard addition
    Subtraction: If result is negative number, print out 4'b11xx, where "x" is don't care
    Multiplication: standard multiplication
    Division: upper 2-bit of the output (result[3:2]) should contain the quotient, and lower 2-bit of the output (result[1:0]) should contain the remainder. Division by 0 should print 4'xxxx.

Operators are first translated to ASCII value, and given as an input. Please refer to ASCII table for each operator.

"m1"~"m4" module is calculational module. It calculates the result based on the given inputs.
"filter" module filters calculational result. Unless the valid bit is set to 1, calculational result given to this module will be filtered out, outputting 0.

To do: You are to fill out the missing part of the following code. Missing parts are noted with "//FILL HERE//". You are not to change any code outside of "//FILL HERE//".

Note that you can use both gate-level (and, or etc), and arithmetic operation(+, - etc).

*/
module calculator
(
    input [1:0] operand_a,
    input [1:0] operand_b,
    input [6:0] operator,
    output [3:0] result
);
	wire [3:0] m1_result;
	wire [3:0] m2_result;
	wire [3:0] m3_result;
	wire [3:0] m4_result;
	
	wire [3:0] m1_result_filtered;
	wire [3:0] m2_result_filtered;
	wire [3:0] m3_result_filtered;
	wire [3:0] m4_result_filtered;
	
    wire m1_valid;
    wire m2_valid;
    wire m3_valid;
    wire m4_valid;

	not (m1_valid, operator[0]);
    xor (m2_valid, operator[2], operator[0]);
    not (m3_valid, operator[1]);
    and (m4_valid, operator[2], operator[1]);
    
    or (result[0], m1_result_filtered[0], m2_result_filtered[0], m3_result_filtered[0], m4_result_filtered[0]);
    or (result[1], m1_result_filtered[1], m2_result_filtered[1], m3_result_filtered[1], m4_result_filtered[1]);
    or (result[2], m1_result_filtered[2], m2_result_filtered[2], m3_result_filtered[2], m4_result_filtered[2]);
    or (result[3], m1_result_filtered[3], m2_result_filtered[3], m3_result_filtered[3], m4_result_filtered[3]);
    
    module1 m1
    (
		.a(operand_a),
		.b(operand_b),
		.result(m1_result)
	);
	module2 m2
    (
		.a(operand_a),
		.b(operand_b),
		.result(m2_result)
	);
	module3 m3
    (
		.a(operand_a),
		.b(operand_b),
		.result(m3_result)
	);
	module4 m4
    (
		.a(operand_a),
		.b(operand_b),
		.result(m4_result)
	);
	
    filter m1_filter
    (
		.in(m1_result),
		.valid(m1_valid),
		.out(m1_result_filtered)
	);
	filter m2_filter
    (
		.in(m2_result),
		.valid(m2_valid),
		.out(m2_result_filtered)
	);
	filter m3_filter
    (
		.in(m3_result),
		.valid(m3_valid),
		.out(m3_result_filtered)
	);
	filter m4_filter
    (
		.in(m4_result),
		.valid(m4_valid),
		.out(m4_result_filtered)
	);
endmodule

module filter
(
	input [3:0] in,
	input valid,
	output [3:0] out
);

	and (out[0], in[0], valid);
	and (out[1], in[1], valid);
	and (out[2], in[2], valid);
	and (out[3], in[3], valid);

endmodule

module module1
(
    input [1:0] a,
    input [1:0] b,
    output [3:0] result
);
/////////////FILL HERE//////////////
	assign result = a* b;
////////////////////////////////////
endmodule

module module2
(
    input [1:0] a,
    input [1:0] b,
    output [3:0] result
);
/////////////FILL HERE//////////////
	assign result = a + b;
////////////////////////////////////
endmodule

module module3
 (
    input [1:0] a,
    input [1:0] b,
    output [3:0] result
);
/////////////FILL HERE//////////////
	wire a1_not, a0_not, b0_not, b1_not;
	not(a1_not, a[1]);
	not(a0_not, a[0]);
	not(b1_not, b[1]);
	not(b0_not,b[0]);
	wire w1, w2, w3;
	and(w1, b[1], a1_not);
	and(w2, a0_not, a1_not, b[0]);
	and(w3, a0_not, b[1], b[0]);
	or(result[3], w1, w2, w3);
	or(result[2], w1, w2, w3);
	wire k1, k2;
	and(k1, a[0], a[1], b1_not);
	and(k2, b0_not, b1_not, a[1]);
	or(result[1], k1, k2);
	xor(result[0], a[0], b[0]);
////////////////////////////////////
endmodule

module module4
(
    input [1:0] a,
    input [1:0] b,
    output [3:0] result
);
/////////////FILL HERE//////////////
	wire a1_not, a0_not, b1_not, b0_not;
	not(a1_not, a[1]);
	not(a0_not, a[0]);
	not(b1_not, b[1]);
	not(b0_not, b[0]);
	and(result[3], a[1], b1_not);
	wire w1, w2, w3;
	and(w1, a[0], b1_not);
	and(w2, a[1], a[0]);
	and(w3, a[1], b0_not);
	or(result[2], w1, w2, w3);
	and(result[1], a[1], a0_not, b[1], b[0]);
	wire k1, k2;
	and(k1, a[0], b[1], a1_not);
	and(k2, a[0], b0_not);
	or(result[0], k1, k2);
////////////////////////////////////
endmodule
