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
    reg signed [AWIDTH+BWIDTH:0]    multr_0, multr, multr_d, multr_dd, multr1_0, multr1, multr1_d, multr1_dd, multi_0, multi, multi_d, multi_dd, multi1_0, multi1, multi1_d, multi1_dd, pr_out, pi_out    ; 
    reg signed [AWIDTH+BWIDTH:0]    common, commonr1, commonr2         ; 
    
    always @(posedge clk)
    begin 
        ar_d <= ar; 
        br_d <= br;
        ai_d <= ai;
        bi_d <= bi;
        
        ar_dd <= ar_d;
        br_dd <= br_d;
        ai_dd <= ai_d;
        bi_dd <= bi_d;
        
        multr <= multr_0;
        multr_dd <= multr_d;
        
        multr1 <= multr1_0;
        multr1_dd <= multr1_d;
        pr_out <= multr1_dd;
        
        multi <= multi_0;
        multi_dd <= multi_d;
        
        multi1 <= multi1_0;
        multi1_dd <= multi1_d;
        pi_out <= multi1_dd;
        
        
    end 
       
    always @(posedge clk)
        begin
            multr_0 <= ar_d * br_d;
            multr_d <= multr + 0;        
        end
    
    always @(posedge clk)
        begin
            multr1_0 <= ai_dd * bi_dd;
            multr1_d <= multr1 + multr_dd;
        end
    always @(posedge clk)
        begin
            multi_0 <= ar_d * bi_d;
            multi_d = multi + 0;
        end
    
    always @(posedge clk)
        begin
            multi1_0 <= ai_dd * br_dd;
            multi1_d <= multi1 + multi_dd;
        end
        
     assign pr = pr_out;
     assign pi = pi_out;
endmodule
