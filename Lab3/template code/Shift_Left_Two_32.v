//Writer:      110550136
//----------------------------------------------
//Subject:     CO project 3 - Shift_Left_Two_32
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 04 / 25
//----------------------------------------------
module Shift_Left_Two_32(
    data_i,
    data_o
    );

parameter size = 0;

//I/O ports                    
input [size-1:0] data_i;
output [size-1:0] data_o;

//shift left 2
assign data_o = {data_i[size-3:0],2'b00};     
endmodule
