//Writer:      110550136     
//----------------------------------------------
//Subject:     CO project 3 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 04 / 25
//----------------------------------------------
module Sign_Extend(
    data_i,
    data_o
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
integer i;
always@(*) begin
    data_o[16-1:0] = data_i;
	for(i=16; i<32; i=i+1)
		data_o[i] = data_i[15];
end          
endmodule      
     