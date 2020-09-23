module missionary_cannibal(clk, reset, missionary_next, cannibal_next, finish);
	//IO declaration
	input clk, reset;
	output [1:0] missionary_next;
	output [1:0] cannibal_next;
	output finish;

	
	//4-bit register
	wire [1:0] missionary_curr;
	wire [1:0] cannibal_curr;
	wire [1:0]missionary_set;
	wire [1:0]cannibal_set;
	or(missionary_set[1], missionary_next[1], reset);
	or(missionary_set[0], missionary_next[0], reset);
	or(cannibal_set[1], cannibal_next[1], reset);
	or(cannibal_set[0], cannibal_next[0], reset);	
	myDFF DFF0(missionary_curr[1],missionary_set[1] , clk, reset);
	myDFF DFF1(missionary_curr[0],missionary_set[0] , clk, reset);
	myDFF DFF2(cannibal_curr[1],cannibal_set[1] , clk, reset);
	myDFF DFF3(cannibal_curr[0],cannibal_set[0], clk, reset);
	
	//reset_state determine whether the direction need to be reset.
	wire reset_state;
	and(reset_state, missionary_next[1], missionary_next[0], cannibal_next[1], cannibal_next[0]);
	//Direction Logic
	wire direction_cur, direction_not, direction_set;
	not(direction_not, direction_cur);
	or(direction_set, reset_state, direction_not);
	myDFF DFF4(direction_cur, direction_set, clk, reset);
	
	
	//Connect the wire to the first project logic
	FirstPrj FristProject(missionary_curr,cannibal_curr, direction_cur, missionary_next, cannibal_next);
	
	wire m_c0not, m_c1not, c_c0not, m_n1not, m_n0not, c_n1not, c_n0not;
	not(m_c0not, missionary_curr[0]);
	not(m_c1not, missionary_curr[1]);
	not(c_c0not, cannibal_curr[0]);
	not(m_n1not, missionary_next[1]);
	not(m_n0not, missionary_next[0]);
	not(c_n1not, cannibal_next[1]);
	not(c_n0not, cannibal_next[0]);
	
	//finish: if next state is final state then finsh is 1
	and(finish, m_c0not, m_c1not, cannibal_curr[1], c_c0not, direction_cur, m_n1not, m_n0not, c_n1not, c_n0not);
endmodule 

//Module: D filp-flop
module myDFF(Q, D, clk, rst);
	output Q;
	input D, clk, rst;
		
	reg Q;
always @ (posedge clk or posedge rst)
begin
	if(rst) Q = 1'b0;
	else Q = D;
end
endmodule 
	
//Module of first term project: Compute the next state
module FirstPrj(missionary_curr, cannibal_curr, direction,missionary_next, cannibal_next);
	//IO ports declaration	
	input [1:0]missionary_curr;
	input[1:0]cannibal_curr;
	input direction;
	output [1:0]missionary_next;
	output [1:0]cannibal_next;
	
		//Inner net definition for missionary_next[1]
	wire w1, w2, w3, w4,w5, w6, w7, w8, w9, w10, direction_not, m1_not, m0_not, c1_not, c0_not;
	
		//Define the inner nets that reverse each input ports.
	not(direction_not, direction);
	not(m1_not, missionary_curr[1]);
	not(m0_not, missionary_curr[0]);
	not(c1_not, cannibal_curr[1]);
	not(c0_not, cannibal_curr[0]);
	
		//Logic in the case that the direction is '1'.
	and(w5, missionary_curr[0], cannibal_curr[1]);
	and(w6, m1_not, c1_not);
	and(w7, c0_not, c1_not);
	and(w8, missionary_curr[1], m0_not, cannibal_curr[0]);
	or(w3, w5, w6, w7, w8);
	and(w1 ,direction, w3);
	
		//Logic in the case that the direction is '0'
	and(w9, c0_not, c1_not);
	and(w10, cannibal_curr[0], cannibal_curr[1]);
	or(w4, missionary_curr[0], missionary_curr[1], w9, w10);
	and(w2 ,direction_not, w4);
	
		//Merge each cases to the logic for missionary_next[1]
	or(missionary_next[1], w1, w2);
		
		//Inner net definition for missionary_next[0]
	wire w11, w12, w13, w14, w15, w16, w17, w18;
	
		//Logic in the case that the direction is '1'
	and(w15, missionary_curr[1], cannibal_curr[0]);
	or(w13, c1_not, missionary_curr[0], w15);
	and(w11 ,direction, w13);
	
		//Logic in the case that the direction is '0'
	and(w18, missionary_curr[0], cannibal_curr[1]);
	and(w17, cannibal_curr[0], cannibal_curr[1]);
	and(w16, c0_not, c1_not);
	or(w14, missionary_curr[1], w16, w17, w18);
	and(w12 ,direction_not, w14);

		//Merge each cases to the logic for missionary_next[0]
	or(missionary_next[0], w11, w12);

		//Inner net definition for cannibal_next[1]
	wire s1, s2, s3, s4, s5, s6, s7, s8;
	
		//Logic in the case that the direction is '1'
	and(s5, c0_not, c1_not);
	and(s6, missionary_curr[0], m1_not);
	and(s7, m0_not, missionary_curr[1]);
	and(s8, m1_not, c1_not);
	or(s3, s5, s6, s7, s8);
	and(s1, direction, s3);

		//Logic in the case that the direction is '0'
	or(s4, cannibal_curr[0], cannibal_curr[1], m1_not, m0_not);
	and(s2, direction_not, s4);
	
		//Merge each cases to the logic for cannibal_next[1]
	or(cannibal_next[1], s1, s2);
	
		//Inner net definition for cannibal_next[0]
	wire s9, s10, s11, s12, s13, s14;

		//Logic in the case that the direction is '1'
	and(s13, missionary_curr[0], m1_not);
	or(s11, cannibal_curr[0], c1_not, s13);
	and(s9, direction, s11);
	
		//Logic in the case that the direction is '0'
	and(s14, missionary_curr[1], m0_not);
	or(s12, cannibal_curr[1], c0_not, s14);
	and(s10, direction_not, s12);
		
		//Merge each cases to the logic for cannibal_next[0]
	or(cannibal_next[0], s9, s10);

endmodule
