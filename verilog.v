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
output reg cout;
output reg [127:0] s;
wire c16, c32, c48, c64, c80, c96, c112, ccout;
wire temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8;
reg [128:0] s1, s2, s3, s4, s5, s6, s7;
reg c1, c2, c3, c4, c5, c6, c7;
reg [127:0] rega, regb;
wire [128:0] sum;
always @ (posedge clk) 
begin
    rega <= a;
    regb <= b;
    s1 <= sum;
    s2 <= s1;
    s3 <= s2;
    s4 <= s3;
    s5 <= s4;
    s6 <= s5;
    s7 <= s6;
    s <= s7;
    c1 <= ccout; 
    c2 <= c1;
    c3 <= c2;
    c4 <= c3;
    c5 <= c4;
    c6 <= c5;
    c7 <= c6;
    cout <= c7;
end 

    rip m1(sum[15:0], temp1, rega[15:0], regb[15:0], cin);
    flip_flop f1(temp1, clk, c16);
    rip m2(sum[31:16], temp2, rega[31:16], regb[31:16], c16);
    flip_flop f2(temp2, clk, c32);
    rip m3(sum[47:32], temp3, rega[47:32], regb[47:32], c32);
    flip_flop f3(temp3, clk, c48);
    rip m4(sum[63:48], temp4, rega[63:48], regb[63:48], c48);
    flip_flop f4(temp4, clk, c64);
    rip m5(sum[79:64], temp5, rega[79:64], regb[79:64], c64);
    flip_flop f5(temp5, clk, c80);
    rip m6(sum[95:80], temp6, rega[95:80], regb[95:80], c80);
    flip_flop f6(temp6, clk, c96);
    rip m7(sum[111:96], temp7, rega[111:96], regb[111:96], c96);
    flip_flop f7(temp7, clk, c112);
    rip m8(sum[127:112], temp8, rega[127:112], regb[127:112], c112);
    flip_flop f8(temp8, clk, ccout);
endmodule 

module flip_flop(d_in, clk, dout);
    input d_in, clk;
    output dout;
    reg d_reg;
    always @ (posedge clk) 
    begin
           d_reg <= d_in;
    end
       
    assign dout = d_reg;
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

///////////////////////////////////////////

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2017 10:32:45 PM
// Design Name: 
// Module Name: test
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

module test;
    reg [127:0] a, b;
    reg cin;
    
    wire [127:0] s;
    wire cout;
    
    reg clk;
    
    rip128 uut(.s(s), .cout(cout), .a(a), .b(b), .cin(cin), .clk(clk));
    
    initial begin 
    clk = 1;
    end
    always begin
    #5 clk=0;
    #5 clk=1;
    end
    
    initial begin 
    a = 0; b = 0; cin =1'b0;
    #100
    
    a= 25; b= 25; cin=1'b0;
    #10
    a = 240; b = 1232; cin=1'b0;
    #10
    a = 32768; b = 85070592; cin=1'b0;
    #10
    a = 8696; b = 6758; cin=1'b0;
    #10
    a = 43; b = 978698; cin=1'b0;
    #10
    a = 12; b = 9; cin=1'b0;
    #10
    a = 987; b = 3456; cin=1'b0;
    #10
    a = 1287; b = 569; cin=1'b0;
    end
    
   
    
    initial begin
    $monitor("time= ", $time, " a = %d, b = %d, cin = %b, sum = %d, cout = %b", a, b, cin, s, cout);
    end
endmodule

