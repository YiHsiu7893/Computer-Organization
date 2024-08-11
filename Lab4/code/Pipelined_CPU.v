//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 4 - Pipelined_CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 12
//----------------------------------------------
`timescale 1ns / 1ps

module Pipelined_CPU(
    clk_i,
    rst_i
);
    
/*==================================================================*/
/*                          input & output                          */
/*==================================================================*/

input clk_i;
input rst_i;

/*==================================================================*/
/*                            reg & wire                            */
/*==================================================================*/

/**** IF stage ****/
wire    [32-1:0]    IF_seqAdd;
wire    [32-1:0]    pc_in;
wire    [32-1:0]    pc_out;
wire    [32-1:0]    IF_instr_o;


/**** ID stage ****/
wire    [32-1:0]    ID_seqAdd;
wire    [32-1:0]    ID_instr_o;
wire    [32-1:0]    ID_read_data1;
wire    [32-1:0]    ID_read_data2;
wire                ID_regWrite;
wire    [3-1:0]     ID_ALUop;
wire                ID_ALUSrc;
wire                ID_regDst;
wire                ID_branch;
wire                ID_memRead;
wire                ID_memWrite;
wire                ID_memtoReg;
wire    [32-1:0]    ID_extend_data;


/**** EX stage ****/
wire                EX_regWrite;
wire                EX_memtoReg;
wire                EX_branch;
wire                EX_memRead;
wire                EX_memWrite;
wire    [3-1:0]     EX_ALUop;
wire                EX_ALUSrc;
wire                EX_regDst;
wire    [32-1:0]    EX_seqAdd;
wire    [32-1:0]    EX_read_data1;
wire    [32-1:0]    EX_read_data2;
wire    [32-1:0]    EX_extend_data;
wire    [5-1:0]     rd0;
wire    [5-1:0]     rd1;
wire    [32-1:0]    shift_data;
wire    [32-1:0]    srcData;
wire    [4-1:0]     ALUCtrl;
wire    [32-1:0]    EX_result;
wire                EX_zero;
wire    [5-1:0]     EX_rd;
wire    [32-1:0]    EX_branchAdd;


/**** MEM stage ****/
wire    [32-1:0]    MEM_branchAdd;
wire                MEM_regWrite;
wire                MEM_memtoReg;
wire                MEM_branch;
wire                MEM_memRead;
wire                MEM_memWrite;
wire                MEM_zero;
wire    [32-1:0]    MEM_result;
wire    [32-1:0]    MEM_read_data2;
wire    [5-1:0]     MEM_rd;
wire    [32-1:0]    MEM_memData;


/**** WB stage ****/
wire    [5-1:0]     WB_rd;
wire    [32-1:0]    Data;
wire                WB_regWrite;
wire                WB_memtoReg;
wire    [32-1:0]    WB_memData;
wire    [32-1:0]    WB_result;



/*==================================================================*/
/*                              design                              */
/*==================================================================*/

//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux0( // Modify N, which is the total length of input/output
        .data0_i(IF_seqAdd),
        .data1_i(MEM_branchAdd),
        .select_i(MEM_branch & MEM_zero),
        .data_o(pc_in)
);

ProgramCounter PC(
        .clk_i(clk_i),
	    .rst_i(rst_i),
	    .pc_in_i(pc_in),
	    .pc_out_o(pc_out)   
);

Instruction_Memory IM(
        .addr_i(pc_out),
        .instr_o(IF_instr_o)   
);
			
Adder Add_pc(
        .src1_i(pc_out),
	    .src2_i(32'd4),
	    .sum_o(IF_seqAdd) 
);
		
Pipe_Reg #(.size(64)) IF_ID( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({IF_seqAdd,IF_instr_o}),
        .data_o({ID_seqAdd,ID_instr_o})
);


//Instantiate the components in ID stage

Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .RSaddr_i(ID_instr_o[25:21]),
        .RTaddr_i(ID_instr_o[20:16]),
        .RDaddr_i(WB_rd),
        .RDdata_i(Data),
        .RegWrite_i(WB_regWrite),
        .RSdata_o(ID_read_data1),
        .RTdata_o(ID_read_data2)   
);

Decoder Control(
        .instr_op_i(ID_instr_o[31:26]),
	    .RegWrite_o(ID_regWrite),
	    .ALU_op_o(ID_ALUop),
	    .ALUSrc_o(ID_ALUSrc),
	    .RegDst_o(ID_regDst),
	    .Branch_o(ID_branch),
        .MemRead_o(ID_memRead),
        .MemWrite_o(ID_memWrite),
        .MemtoReg_o(ID_memtoReg)    
);

Sign_Extend SE(
        .data_i(ID_instr_o[15:0]),
        .data_o(ID_extend_data)  
);

Pipe_Reg #(.size(148)) ID_EX( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({ID_regWrite, ID_memtoReg, ID_branch, ID_memRead, ID_memWrite, ID_ALUop, ID_ALUSrc, ID_regDst, ID_seqAdd,
                 ID_read_data1, ID_read_data2, ID_extend_data, ID_instr_o[20:16], ID_instr_o[15:11]}),
        .data_o({EX_regWrite, EX_memtoReg, EX_branch, EX_memRead, EX_memWrite, EX_ALUop, EX_ALUSrc, EX_regDst, EX_seqAdd,
                 EX_read_data1, EX_read_data2, EX_extend_data, rd0, rd1})
);


//Instantiate the components in EX stage

Shift_Left_Two_32 Shifter(
        .data_i(EX_extend_data),
        .data_o(shift_data)
);

ALU ALU(
        .src1_i(EX_read_data1),
	    .src2_i(srcData),
	    .ctrl_i(ALUCtrl),
	    .result_o(EX_result),
	    .zero_o(EX_zero)
);
		
ALU_Ctrl ALU_Control(
        .funct_i(EX_extend_data[5:0]),
        .ALUOp_i(EX_ALUop),
        .ALUCtrl_o(ALUCtrl) 
);

MUX_2to1 #(.size(32)) Mux1( // Modify N, which is the total length of input/output
        .data0_i(EX_read_data2),
        .data1_i(EX_extend_data),
        .select_i(EX_ALUSrc),
        .data_o(srcData)
);
		
MUX_2to1 #(.size(5)) Mux2( // Modify N, which is the total length of input/output
        .data0_i(rd0),
        .data1_i(rd1),
        .select_i(EX_regDst),
        .data_o(EX_rd)
);

Adder Add_pc_branch(
        .src1_i(EX_seqAdd),
	    .src2_i(shift_data),
	    .sum_o(EX_branchAdd)   
);

Pipe_Reg #(.size(107)) EX_MEM( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({EX_regWrite, EX_memtoReg, EX_branch, EX_memRead, EX_memWrite, EX_branchAdd, EX_zero, EX_result, EX_read_data2, EX_rd}),
        .data_o({MEM_regWrite, MEM_memtoReg, MEM_branch, MEM_memRead, MEM_memWrite, MEM_branchAdd, MEM_zero, MEM_result, MEM_read_data2, MEM_rd})
);


//Instantiate the components in MEM stage

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(MEM_result),
        .data_i(MEM_read_data2),
        .MemRead_i(MEM_memRead),
        .MemWrite_i(MEM_memWrite),
        .data_o(MEM_memData)

);

Pipe_Reg #(.size(71)) MEM_WB( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .data_i({MEM_regWrite, MEM_memtoReg, MEM_memData, MEM_result, MEM_rd}),
        .data_o({WB_regWrite, WB_memtoReg, WB_memData, WB_result, WB_rd})
);


//Instantiate the components in WB stage

MUX_2to1 #(.size(32)) Mux3( // Modify N, which is the total length of input/output
        .data0_i(WB_memData),
        .data1_i(WB_result),
        .select_i(WB_memtoReg),
        .data_o(Data)
);


endmodule
