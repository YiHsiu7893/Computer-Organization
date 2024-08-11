//Writer:      110550136 
//----------------------------------------------
//Subject:     CO project 4 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 12
//----------------------------------------------
module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;   
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;
  
//Select exact operation
always@(*) begin
    ALUCtrl_o[3] <= funct_i[4] & ALUOp_i[1];
	ALUCtrl_o[2] <= (~funct_i[2] & funct_i[1] & ALUOp_i[1]) | ALUOp_i[0];
	ALUCtrl_o[1] <= (~funct_i[3] & ~funct_i[2]) | funct_i[1] | (~ALUOp_i[1]);
	ALUCtrl_o[0] <= (funct_i[0] & ALUOp_i[1]) | (funct_i[2] & funct_i[1] & ALUOp_i[1]) | (funct_i[3] & funct_i[1] & ALUOp_i[1]) | (ALUOp_i[2] & ALUOp_i[0]);
end
endmodule                       