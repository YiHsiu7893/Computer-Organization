//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 4 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 13
//----------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
    MemRead_o,
    MemWrite_o,
    MemtoReg_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            MemtoReg_o;

//Main function
always@(instr_op_i)begin
    RegDst_o <= ~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1];
	ALU_op_o[2] <= (~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1]) | (~instr_op_i[2] & instr_op_i[1] & ~instr_op_i[0]);
	ALU_op_o[1] <= ~instr_op_i[3] & ~instr_op_i[2] & ~instr_op_i[1];
	ALU_op_o[0] <= ~instr_op_i[5] & (instr_op_i[2] | instr_op_i[1]);
	ALUSrc_o <= instr_op_i[5] | instr_op_i[3];
	Branch_o <= instr_op_i[2];
	RegWrite_o <=  (~instr_op_i[2] & ~instr_op_i[0]) | (instr_op_i[5] & ~instr_op_i[3]);
	MemRead_o <= instr_op_i[5] & ~instr_op_i[3];
	MemWrite_o <= instr_op_i[5] & instr_op_i[3];
	MemtoReg_o <= ~instr_op_i[0];
end
endmodule               
