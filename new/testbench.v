`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 04:40:59 PM
// Design Name: 
// Module Name: testbench
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


module testbench ();

  reg signed [17:0] A, a, B, b;
  wire signed [35:0] re1, im1, re2, im2;
  reg clk;

  // calculates (A+a*i)*(B+b*i) = re + im*i
  //part1 p1(clk,A,a,B,b,re1,im1);
  cmult p1(clk,A,a,B,b,re1,im1);
  part2 p2(clk,A,a,B,b,re2,im2);

  initial clk = 0;
  always #5 clk = ~clk;
  initial #1000 $finish();

  initial $monitor("part 1: (%d + %di) * (%d + %di) = %d + %di", A, a, B, b, re1, im1);
  initial $monitor("part 2: (%d + %di) * (%d + %di) = %d + %di", A, a, B, b, re2, im2);

  initial begin
    #100;
    A <= 1;
    a <= 2;
    B <= 3;
    b <= 4;

    #100;
    A <= 5;
    a <= 6;
    B <= 7;
    b <= 8;
  end

endmodule

