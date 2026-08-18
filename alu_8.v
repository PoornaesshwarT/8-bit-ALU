`timescale 1ns / 1ps
module alu_8(
input [7:0]A,B,
input [2:0]opcode,
output reg [7:0]Y,
output reg Z,
output reg C,
output reg V,
output reg N
    );
    reg[8:0] temp;
    always @(*)begin
        Y=8'b0000_0000;
        Z=0;C=0;V=0;N=0;
        case(opcode)
            3'b000:begin
                 temp = A+B;
                 Y= temp[7:0];
                 C= temp[8];
                 V=(~(A[7] ^ B[7])&(A[7] ^ Y[7]));
            end
            3'b001:begin
                temp = A-B;
                Y= temp[7:0];
                C= temp[8];
                V=(A[7] ^ B[7])&(A[7] ^ Y[7]);
            end
            3'b010:Y=A&B;
            3'b011:Y=A|B;
            3'b100:Y=A^B;
            3'b101:Y=~A;
            3'b110:begin
                Y=A<<1;
                C=A[7];
                end
            3'b111:begin
            Y=A>>1;
            C=A[0];
            end
            default:Y=8'b0000_0000;
        endcase
        Z=(Y==8'b0000_0000);
        N=Y[7];
     end
endmodule
