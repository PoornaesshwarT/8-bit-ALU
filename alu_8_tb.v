`timescale 1ns / 1ps
module alu_8_tb;
reg [7:0]A,B;
reg [2:0]opcode;
wire [7:0]Y;
wire C,V,N,Z;
integer i;
alu_8 uut(.A(A),.B(B),.opcode(opcode),.Y(Y),.C(C),.N(N),.Z(Z),.V(V));
initial begin
    A=0;B=0;opcode=0;#10;
    for(i=0;i<100;i=i+1)begin
        A=$random;
        B=$random;
        opcode=$random &3'b111;#10;
    end
$finish;
end
endmodule
