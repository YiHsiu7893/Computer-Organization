//Writer:      110550136
//----------------------------------------------
//Subject:     CO project 5 - Hazard_Detector
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 27
//----------------------------------------------
module Hazard_Detector(
			   IDEX_memRead,
               IDEX_rT,
               IFID_rS,
               IFID_rT,
			   Branch,
			   IF_flush,
			   ID_flush,
			   EX_flush,
			   PC_write,
			   IFID_write
               );		   
			
//I/O ports               
input   		   IDEX_memRead;          
input   [5-1:0]  IDEX_rT;
input   [5-1:0]  IFID_rS;
input   [5-1:0]  IFID_rT; 
input			    Branch;
output			IF_flush;
output	        ID_flush;
output			EX_flush;
output			PC_write;
output		    IFID_write;

//Internal Signals
reg			   	   IF_flush;
reg			   	   ID_flush;
reg			   	   EX_flush;
reg			  	   PC_write;
reg			  	   IFID_write;

//Main function
always@(*) begin
if(Branch) begin
	IF_flush <= 1;
	ID_flush <= 1;
	EX_flush <= 1;
	PC_write <= 1;
	IFID_write <= 1;	
end

else if(IDEX_memRead && (IDEX_rT == IFID_rS || IDEX_rT == IFID_rT)) begin
		IF_flush <= 0;
		ID_flush <= 1;
		EX_flush <= 0;
		PC_write <= 0;
		IFID_write <= 0;
end

else begin
    IF_flush <= 0;
	ID_flush <= 0;
	EX_flush <= 0;
	PC_write <= 1;
	IFID_write <= 1;
end
end
endmodule        