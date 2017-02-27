`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 04:42:54 PM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst,
    output reg [35:0] dataouti, dataoutr
    );
    
    reg signed [17:0] A, a, B, b;
    wire signed [35:0] re1, im1;
    
    //cmult p1(clk,A,a,B,b,re1,im1);
    part2 p2(clk,A,a,B,b,re2,im2);
    always @ (posedge clk)
    begin 
        dataoutr <= re1;
        dataouti <= im1;
        if(rst) begin
            A <= 16'b0;
            a <= 16'b0;
            B <= 16'b0;
            b <= 16'b0;
        end
    end
endmodule
