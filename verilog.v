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
reg [127:0] rega, regb;
reg [128:0] sum;
always @ (posedge clk) 
begin
    rega <= a;
    regb <= b;
end 
    rip m1(s[15:0], c16, rega[15:0], regb[15:0], cin);
    rip m2(s[31:16], c32, rega[31:16], regb[31:16], c16);
    rip m3(s[47:32], c48, rega[47:32], regb[47:32], c32);
    rip m4(s[63:48], c64, rega[63:48], regb[63:48], c48);
    rip m5(s[79:64], c80, rega[79:64], regb[79:64], c64);
    rip m6(s[95:80], c96, rega[95:80], regb[95:80], c80);
    rip m7(s[111:96], c112, rega[111:96], regb[111:96], c96);
    rip m8(s[127:112], cout, rega[127:112], regb[127:112], c112);

endmodule 

module flip_flop(d_in, clk, dout);
    input d_in, clk;
    output dout;
    reg d_reg;
    always @(posedge clk) 
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


///////////////////////////////////////////////////
//test.v 

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
    clk = 0;
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
    end
   
    
    initial begin
    $monitor("time= ", $time, " a = %d, b = %d, cin = %b, sum = %d, cout = %b", a, b, cin, s, cout);
    end
endmodule
