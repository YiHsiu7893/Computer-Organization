//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 4 - Adder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 11
//----------------------------------------------
`timescale 1ns/1ps
module Adder(
    src1_i,
	src2_i,
	sum_o
	);
     
//I/O ports
input  [32-1:0]   src1_i;
input  [32-1:0]	 src2_i;
output [32-1:0]	 sum_o;

//Internal Signals
wire    [32-1:0]	 sum_o;
wire    [32-1:0] carry;

// 32-bit adder
        full_adder Add00(src1_i[0],src2_i[0],1'b0,sum_o[0],carry[0]);
        full_adder Add01(src1_i[1],src2_i[1],carry[0],sum_o[1],carry[1]);
        full_adder Add02(src1_i[2],src2_i[2],carry[1],sum_o[2],carry[2]);
        full_adder Add03(src1_i[3],src2_i[3],carry[2],sum_o[3],carry[3]);
        full_adder Add04(src1_i[4],src2_i[4],carry[3],sum_o[4],carry[4]);
        full_adder Add05(src1_i[5],src2_i[5],carry[4],sum_o[5],carry[5]);
        full_adder Add06(src1_i[6],src2_i[6],carry[5],sum_o[6],carry[6]);
        full_adder Add07(src1_i[7],src2_i[7],carry[6],sum_o[7],carry[7]);
        full_adder Add08(src1_i[8],src2_i[8],carry[7],sum_o[8],carry[8]);
        full_adder Add09(src1_i[9],src2_i[9],carry[8],sum_o[9],carry[9]);
        full_adder Add10(src1_i[10],src2_i[10],carry[9],sum_o[10],carry[10]);
        full_adder Add11(src1_i[11],src2_i[11],carry[10],sum_o[11],carry[11]);
        full_adder Add12(src1_i[12],src2_i[12],carry[11],sum_o[12],carry[12]);
        full_adder Add13(src1_i[13],src2_i[13],carry[12],sum_o[13],carry[13]);
        full_adder Add14(src1_i[14],src2_i[14],carry[13],sum_o[14],carry[14]);
        full_adder Add15(src1_i[15],src2_i[15],carry[14],sum_o[15],carry[15]);
        full_adder Add16(src1_i[16],src2_i[16],carry[15],sum_o[16],carry[16]);
        full_adder Add17(src1_i[17],src2_i[17],carry[16],sum_o[17],carry[17]);
        full_adder Add18(src1_i[18],src2_i[18],carry[17],sum_o[18],carry[18]);
        full_adder Add19(src1_i[19],src2_i[19],carry[18],sum_o[19],carry[19]);
        full_adder Add20(src1_i[20],src2_i[20],carry[19],sum_o[20],carry[20]);
        full_adder Add21(src1_i[21],src2_i[21],carry[20],sum_o[21],carry[21]);
        full_adder Add22(src1_i[22],src2_i[22],carry[21],sum_o[22],carry[22]);
        full_adder Add23(src1_i[23],src2_i[23],carry[22],sum_o[23],carry[23]);
        full_adder Add24(src1_i[24],src2_i[24],carry[23],sum_o[24],carry[24]);
        full_adder Add25(src1_i[25],src2_i[25],carry[24],sum_o[25],carry[25]);
        full_adder Add26(src1_i[26],src2_i[26],carry[25],sum_o[26],carry[26]);
        full_adder Add27(src1_i[27],src2_i[27],carry[26],sum_o[27],carry[27]);
        full_adder Add28(src1_i[28],src2_i[28],carry[27],sum_o[28],carry[28]);
        full_adder Add29(src1_i[29],src2_i[29],carry[28],sum_o[29],carry[29]);
        full_adder Add30(src1_i[30],src2_i[30],carry[29],sum_o[30],carry[30]);
        full_adder Add31(src1_i[31],src2_i[31],carry[30],sum_o[31],carry[31]);
endmodule


module full_adder(a,b,cin,result,cout);

input a,b,cin;
output result,cout;

assign result = a ^ b ^ cin;
assign cout = (a & b) | (a & cin) | (b & cin);
endmodule                              
