`timescale 1ns/1ps
// YiHsiu
module alu_top(
    /* input */
    src1,       //1 bit, source 1 (A)
    src2,       //1 bit, source 2 (B)
    less,       //1 bit, less
    A_invert,   //1 bit, A_invert
    B_invert,   //1 bit, B_invert
    cin,        //1 bit, carry in
    operation,  //2 bit, operation
    /* output */
    result,     //1 bit, result
    cout        //1 bit, carry out
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input src1;
input src2;
input less;
input A_invert;
input B_invert;
input cin;
input [1:0] operation;

output result;
output cout;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg result, cout;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/
always@(*) begin       
    case({A_invert , B_invert , operation})
        4'b0000: result = src1 & src2;
        4'b0001: result = src1 | src2;
        4'b0010: begin
        cout = (src1 & src2) | (src1 & cin) | (src2 & cin);
        result = src1 ^ src2 ^ cin;
        end
        4'b0110: begin
        cout = (src1 & ~src2) | (src1 & cin) | (~src2 & cin);
        result = src1 ^ (~src2) ^ cin;
        end
        4'b1100: result = (~src1) & (~src2);
        4'b0111: begin
        cout = (src1 & ~src2) | (src1 & cin) | (~src2 & cin);
        result = less;   
        end     
        default: begin
            result = 1'b0;
        end
    endcase
end
endmodule
