`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 05:26:59 PM
// Design Name: 
// Module Name: part2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module part2 # (parameter AWIDTH = 18, BWIDTH = 18)(
    input clk,
    input signed [AWIDTH-1:0] 	    ar, ai,
    input signed [BWIDTH-1:0] 	    br, bi,
    output signed [AWIDTH+BWIDTH:0] pr, pi
    );
        
    reg signed [AWIDTH-1:0]	ai_d, ai_dd, ai_ddd, ai_dddd		 ; 
    reg signed [AWIDTH-1:0]    ar_d, ar_dd, ar_ddd, ar_dddd         ; 
    reg signed [BWIDTH-1:0]    bi_d, bi_dd, bi_ddd, br_d, br_dd, br_ddd ; 
    reg signed [AWIDTH:0]        addcommon        ; 
    reg signed [BWIDTH:0]        addr, addi     ; 
    reg signed [AWIDTH+BWIDTH:0]    multrr, multii, multir, multri, pr_out, pi_out    ; 
    reg signed [AWIDTH+BWIDTH:0]    common, commonr1, commonr2         ; 
    
    always @(posedge clk)
        begin 
            multrr <= ar * br; 
            multri <= ar * bi;
            multir <= ai * br;
            multii <= ai * bi; 
        end 
       
    always @(posedge clk)
        begin
            pr_out <= multrr - multii;
            pi_out <= multri + multir;       
        end
    
    
        
     assign pr = pr_out;
     assign pi = pi_out;
endmodule
