`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2017 10:22:46 PM
// Design Name: 
// Module Name: adder
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
module rip128(s, cout, a, b, cin, clk);
input [127:0] a;
input [127:0] b;
input cin;
input clk;
output cout;
output [127:0] s;
wire c16, c32, c48, c64, c80, c96, c112, cout;
reg [127:0] a_in, b_in;
reg [128:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7, sum8, sum9 ;
always @ (posedge clk) begin
    a_in <= a;
    b_in <= b;

end 
    rip m1(s[15:0], c16, a_in[15:0], b_in[15:0], cin);
    rip m2(s[31:16], c32, a_in[31:16], b_in[31:16], c16);
    rip m3(s[47:32], c48, a_in[47:32], b_in[47:32], c32);
    rip m4(s[63:48], c64, a_in[63:48], b_in[63:48], c48);
    rip m5(s[79:64], c80, a_in[79:64], b_in[79:64], c64);
    rip m6(s[95:80], c96, a_in[95:80], b_in[95:80], c80);
    rip m7(s[111:96], c112, a_in[111:96], b_in[111:96], c96);
    rip m8(s[127:112], cout, a_in[127:112], b_in[127:112], c112);

endmodule 

module rip(s,cout,a,b,cin);
input [15:0]a;
input [15:0]b;
input cin;
output cout;
output [15:0]s;
wire c4,c8,c12,cout;
rip2 m1(s[3:0],c4,a[3:0],b[3:0],cin);
rip2 m2(s[7:4],c8,a[7:4],b[7:4],c4);
rip2 m3(s[11:8],c12,a[11:8],b[11:8],c8);
rip2 m4(s[15:12],cout,a[15:12],b[15:12],c12);

endmodule

module rip2(s,cout,a,b,cin);
  input [3:0]a;
  input [3:0]b;
  input cin;
  output cout;
  output [3:0]s;
  wire c2,c3,c4,cout;
  fa m1(s[0],c2,a[0],b[0],cin);
  fa m2(s[1],c3,a[1],b[1],c2);
  fa m3(s[2],c4,a[2],b[2],c3);
  fa m4(s[3],cout,a[3],b[3],c4);
endmodule

module fa(s,cout,a,b,cin);
input a,b,cin;
output s,cout;
wire w1,w2,w3;
ha m1(w1,w2,a,b);
ha m2(s,w3,w1,cin);
or m3(cout,w2,w3);
endmodule

module ha(s,cout,a,b);
  input a,b;
  output s,cout;
  xor m1(s,a,b);
  and m2(cout,a,b);
endmodule
