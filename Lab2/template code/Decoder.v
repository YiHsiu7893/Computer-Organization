//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 04 / 22
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Main function
always@(instr_op_i)begin
    RegWrite_o <= ~instr_op_i[2];
    ALU_op_o <= {instr_op_i[3],instr_op_i[2],instr_op_i[1]};
    ALUSrc_o <= instr_op_i[3];
    RegDst_o <= ~instr_op_i[3];
    Branch_o <= instr_op_i[2];
end
endmodule             
