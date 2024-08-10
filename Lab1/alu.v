`timescale 1ns/1ps
// YiHsiu
module alu(
    /* input */
    clk,            // system clock
    rst_n,          // negative reset
    src1,           // 32 bits, source 1
    src2,           // 32 bits, source 2
    ALU_control,    // 4 bits, ALU control input
    /* output */
    result,         // 32 bits, result
    zero,           // 1 bit, set to 1 when the output is 0
    cout,           // 1 bit, carry out
    overflow        // 1 bit, overflow
);

/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk;
input rst_n;
input [31:0] src1;
input [31:0] src2;
input [3:0] ALU_control;

output [32-1:0] result;
output zero;
output cout;
output overflow;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

reg [32-1:0] result;
reg zero, cout, overflow;
wire [31:0] result_temp;
wire [31:0] cout_temp;
wire set;
wire overflow_temp;

/*==================================================================*/
/*                              design                              */
/*==================================================================*/

// 32-bit ALU
        alu_top ALU00(.src1(src1[0]), .src2(src2[0]), .less(set), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(ALU_control[2]), .operation(ALU_control[1:0]), .result(result_temp[0]), .cout(cout_temp[0]));
        alu_top ALU01(.src1(src1[1]), .src2(src2[1]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[0]), .operation(ALU_control[1:0]), .result(result_temp[1]), .cout(cout_temp[1]));
        alu_top ALU02(.src1(src1[2]), .src2(src2[2]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[1]), .operation(ALU_control[1:0]), .result(result_temp[2]), .cout(cout_temp[2]));
        alu_top ALU03(.src1(src1[3]), .src2(src2[3]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[2]), .operation(ALU_control[1:0]), .result(result_temp[3]), .cout(cout_temp[3]));
        alu_top ALU04(.src1(src1[4]), .src2(src2[4]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[3]), .operation(ALU_control[1:0]), .result(result_temp[4]), .cout(cout_temp[4]));
        alu_top ALU05(.src1(src1[5]), .src2(src2[5]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[4]), .operation(ALU_control[1:0]), .result(result_temp[5]), .cout(cout_temp[5]));
        alu_top ALU06(.src1(src1[6]), .src2(src2[6]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[5]), .operation(ALU_control[1:0]), .result(result_temp[6]), .cout(cout_temp[6]));
        alu_top ALU07(.src1(src1[7]), .src2(src2[7]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[6]), .operation(ALU_control[1:0]), .result(result_temp[7]), .cout(cout_temp[7]));
        alu_top ALU08(.src1(src1[8]), .src2(src2[8]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[7]), .operation(ALU_control[1:0]), .result(result_temp[8]), .cout(cout_temp[8]));
        alu_top ALU09(.src1(src1[9]), .src2(src2[9]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[8]), .operation(ALU_control[1:0]), .result(result_temp[9]), .cout(cout_temp[9]));
        alu_top ALU10(.src1(src1[10]), .src2(src2[10]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[9]), .operation(ALU_control[1:0]), .result(result_temp[10]), .cout(cout_temp[10]));
        alu_top ALU11(.src1(src1[11]), .src2(src2[11]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[10]), .operation(ALU_control[1:0]), .result(result_temp[11]), .cout(cout_temp[11]));
        alu_top ALU12(.src1(src1[12]), .src2(src2[12]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[11]), .operation(ALU_control[1:0]), .result(result_temp[12]), .cout(cout_temp[12]));
        alu_top ALU13(.src1(src1[13]), .src2(src2[13]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[12]), .operation(ALU_control[1:0]), .result(result_temp[13]), .cout(cout_temp[13]));
        alu_top ALU14(.src1(src1[14]), .src2(src2[14]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[13]), .operation(ALU_control[1:0]), .result(result_temp[14]), .cout(cout_temp[14]));
        alu_top ALU15(.src1(src1[15]), .src2(src2[15]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[14]), .operation(ALU_control[1:0]), .result(result_temp[15]), .cout(cout_temp[15]));
        alu_top ALU16(.src1(src1[16]), .src2(src2[16]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[15]), .operation(ALU_control[1:0]), .result(result_temp[16]), .cout(cout_temp[16]));
        alu_top ALU17(.src1(src1[17]), .src2(src2[17]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[16]), .operation(ALU_control[1:0]), .result(result_temp[17]), .cout(cout_temp[17]));
        alu_top ALU18(.src1(src1[18]), .src2(src2[18]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[17]), .operation(ALU_control[1:0]), .result(result_temp[18]), .cout(cout_temp[18]));
        alu_top ALU19(.src1(src1[19]), .src2(src2[19]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[18]), .operation(ALU_control[1:0]), .result(result_temp[19]), .cout(cout_temp[19]));
        alu_top ALU20(.src1(src1[20]), .src2(src2[20]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[19]), .operation(ALU_control[1:0]), .result(result_temp[20]), .cout(cout_temp[20]));
        alu_top ALU21(.src1(src1[21]), .src2(src2[21]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[20]), .operation(ALU_control[1:0]), .result(result_temp[21]), .cout(cout_temp[21]));
        alu_top ALU22(.src1(src1[22]), .src2(src2[22]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[21]), .operation(ALU_control[1:0]), .result(result_temp[22]), .cout(cout_temp[22]));
        alu_top ALU23(.src1(src1[23]), .src2(src2[23]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[22]), .operation(ALU_control[1:0]), .result(result_temp[23]), .cout(cout_temp[23]));
        alu_top ALU24(.src1(src1[24]), .src2(src2[24]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[23]), .operation(ALU_control[1:0]), .result(result_temp[24]), .cout(cout_temp[24]));
        alu_top ALU25(.src1(src1[25]), .src2(src2[25]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[24]), .operation(ALU_control[1:0]), .result(result_temp[25]), .cout(cout_temp[25]));
        alu_top ALU26(.src1(src1[26]), .src2(src2[26]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[25]), .operation(ALU_control[1:0]), .result(result_temp[26]), .cout(cout_temp[26]));
        alu_top ALU27(.src1(src1[27]), .src2(src2[27]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[26]), .operation(ALU_control[1:0]), .result(result_temp[27]), .cout(cout_temp[27]));
        alu_top ALU28(.src1(src1[28]), .src2(src2[28]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[27]), .operation(ALU_control[1:0]), .result(result_temp[28]), .cout(cout_temp[28]));
        alu_top ALU29(.src1(src1[29]), .src2(src2[29]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[28]), .operation(ALU_control[1:0]), .result(result_temp[29]), .cout(cout_temp[29]));
        alu_top ALU30(.src1(src1[30]), .src2(src2[30]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[29]), .operation(ALU_control[1:0]), .result(result_temp[30]), .cout(cout_temp[30]));
        alu_31 ALU31(.src1(src1[31]), .src2(src2[31]), .less(1'b0), .A_invert(ALU_control[3]), .B_invert(ALU_control[2]), .cin(cout_temp[30]), .operation(ALU_control[1:0]), .result(result_temp[31]), .cout(cout_temp[31]), .set(set), .overflow(overflow_temp));

always@(posedge clk or negedge rst_n) 
begin
	if(!rst_n) begin
        result = 0;
        zero = 0;
        cout = 0;
        overflow = 0;
	end
	else begin     
        result = result_temp;
        
        zero = ~(result[0] | result[1] | result[2] | result[3] | result[4] | result[5] | result[6] | result[7] | result[8] | result[9] | result[10] |
	          result[11] | result[12] | result[13] | result[14] | result[15] | result[16] | result[17] | result[18] | result[19] | result[20] |
	          result[21] | result[22] | result[23] | result[24] | result[25] | result[26] | result[27] | result[28] | result[29] | result[30] | result[31]) ;	
	          
        if(ALU_control == 2 || ALU_control == 6)begin
            cout = cout_temp[31];
            overflow = overflow_temp;
        end
        else begin
            cout = 0;    
            overflow = 0;
        end      
    end
end 
endmodule
