//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 5 - Forwarding
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 26
//----------------------------------------------
module Forwarding(
			EXMEM_regWrite,
			EXMEM_rD,
            MEMWB_regWrite,
            MEMWB_rD,
            IDEX_rS,
			IDEX_rT,
			ForwardA,
			ForwardB
            );		   
			
//I/O ports               
input   		      EXMEM_regWrite;          
input   [5-1:0]    EXMEM_rD;
input   		      MEMWB_regWrite;          
input   [5-1:0]    MEMWB_rD;
input   [5-1:0]    IDEX_rS;
input   [5-1:0]    IDEX_rT;
output	[1:0]	  ForwardA;
output	[1:0]	  ForwardB;

//Internal Signals
reg		[1:0]	  ForwardA;
reg		[1:0]	  ForwardB;

//Main function
always@(*) begin
if(EXMEM_regWrite && (EXMEM_rD != 5'b0) && EXMEM_rD == IDEX_rS) ForwardA <= 2'b10;
else if (MEMWB_regWrite && (MEMWB_rD != 5'b0) && ~(EXMEM_regWrite && (EXMEM_rD != 5'b0) && EXMEM_rD == IDEX_rS) && MEMWB_rD == IDEX_rS) ForwardA <= 2'b01;
else ForwardA <= 2'b00;

if(EXMEM_regWrite && (EXMEM_rD != 5'b0) && EXMEM_rD == IDEX_rT) ForwardB <= 2'b10;
else if (MEMWB_regWrite && (MEMWB_rD != 5'b0) && ~(EXMEM_regWrite && (EXMEM_rD != 5'b0) && EXMEM_rD == IDEX_rT) && MEMWB_rD == IDEX_rT) ForwardB <= 2'b01;
else ForwardB <= 2'b00;
end
endmodule   
