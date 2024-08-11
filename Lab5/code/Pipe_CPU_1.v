//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 5 - Pipelined_CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 05 / 26
//----------------------------------------------
`timescale 1ns / 1ps

module Pipe_CPU_1(
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
wire                PCWrite;
wire                IF_flush;
wire                IFID_write;
wire    [32-1:0]    ID_seqAdd;
wire    [32-1:0]    ID_instr_o;
wire    [32-1:0]    ID_read_data1;
wire    [32-1:0]    ID_read_data2;
wire                init_regDst;
wire    [3-1:0]     init_ALUop;
wire                init_ALUSrc;
wire                init_regWrite;
wire                init_branch;
wire    [2-1:0]     init_btype;
wire                init_memRead;
wire                init_memWrite;
wire                init_memtoReg;
wire                ID_flush;
wire                ID_regDst;
wire    [3-1:0]     ID_ALUop;
wire                ID_ALUSrc;
wire                ID_regWrite;
wire                ID_branch;
wire    [2-1:0]     ID_btype;
wire                ID_memRead;
wire                ID_memWrite;
wire                ID_memtoReg;
wire    [32-1:0]    ID_extend_data;
wire                EX_flush;


/**** EX stage ****/
wire                EX_regWrite;
wire                EX_memtoReg;
wire                EX_branch;
wire                EX_memRead;
wire                EX_memWrite;
wire    [3-1:0]     EX_ALUop;
wire                EX_ALUSrc;
wire                EX_regDst;
wire    [2-1:0]     EX_btype;
wire    [32-1:0]    EX_seqAdd;
wire    [32-1:0]    EX_read_data1;
wire    [32-1:0]    EX_read_data2;
wire    [32-1:0]    EX_extend_data;
wire    [5-1:0]     IDEX_rs;
wire    [5-1:0]     IDEX_rt;
wire    [5-1:0]     IDEX_rd;
wire    [32-1:0]    shift_data;
wire    [2-1:0]     selectA;
wire    [32-1:0]    EX_op_data1;
wire    [2-1:0]     selectB;
wire    [32-1:0]    EX_op_data2;
wire    [32-1:0]    srcData;
wire    [4-1:0]     ALUCtrl;
wire    [32-1:0]    EX_result;
wire                EX_zero;
wire    [5-1:0]     EX_rd;
wire    [32-1:0]    EX_branchAdd;
wire                EX_op_regWrite;
wire                EX_op_memtoReg;
wire                EX_op_branch;
wire                EX_op_memRead;
wire                EX_op_memWrite;
wire    [2-1:0]     EX_op_btype;


/**** MEM stage ****/
wire                PCSrc = MEM_branch & typeBranch;
wire    [32-1:0]    MEM_branchAdd;
wire    [32-1:0]    MEM_result;
wire                MEM_regWrite;
wire    [5-1:0]     MEM_rd;
wire                MEM_memtoReg;
wire                MEM_branch;
wire                MEM_memRead;
wire                MEM_memWrite;
wire    [2-1:0]     MEM_btype;
wire                MEM_zero;
wire    [32-1:0]    MEM_read_data2;
wire    [32-1:0]    MEM_memData;
wire                typeBranch;


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
        .select_i(PCSrc),
        .data_o(pc_in)
);

ProgramCounter PC(
        .clk_i(clk_i),
	    .rst_i(rst_i),
	    .pc_write(PCWrite),
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
        .flush(IF_flush),
        .write(IFID_write),
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
        .RegDst_o(init_regDst),
	    .ALU_op_o(init_ALUop),
	    .ALUSrc_o(init_ALUSrc),
	    .RegWrite_o(init_regWrite),
	    .Branch_o(init_branch),
	    .BranchType_o(init_btype),
        .MemRead_o(init_memRead),
        .MemWrite_o(init_memWrite),
        .MemtoReg_o(init_memtoReg)    
);

MUX_2to1 #(.size(12)) Mux_EXFlush( // Modify N, which is the total length of input/output
        .data0_i({init_regDst, init_ALUop, init_ALUSrc, init_regWrite, init_branch, init_btype, init_memRead, init_memWrite, init_memtoReg}),
        .data1_i(12'b0),
        .select_i(ID_flush),
        .data_o({ID_regDst, ID_ALUop, ID_ALUSrc, ID_regWrite, ID_branch, ID_btype, ID_memRead, ID_memWrite, ID_memtoReg})
);

Sign_Extend SE(
        .data_i(ID_instr_o[15:0]),
        .data_o(ID_extend_data)  
);

Pipe_Reg #(.size(155)) ID_EX( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush(1'b0),
        .write(1'b1),
        .data_i({ID_regWrite, ID_memtoReg, ID_branch, ID_memRead, ID_memWrite, ID_ALUop, ID_ALUSrc, ID_regDst, ID_btype,
                 ID_seqAdd, ID_read_data1, ID_read_data2, ID_extend_data, ID_instr_o[25:21], ID_instr_o[20:16], ID_instr_o[15:11]}),
        .data_o({EX_regWrite, EX_memtoReg, EX_branch, EX_memRead, EX_memWrite, EX_ALUop, EX_ALUSrc, EX_regDst, EX_btype,
                 EX_seqAdd, EX_read_data1, EX_read_data2, EX_extend_data, IDEX_rs, IDEX_rt, IDEX_rd})
);
	   
Hazard_Detector HDunit(
			   .IDEX_memRead(EX_memRead),
               .IDEX_rT(IDEX_rt),
               .IFID_rS(ID_instr_o[25:21]),
               .IFID_rT(ID_instr_o[20:16]),
			   .Branch(PCSrc),
			   .IF_flush(IF_flush),
			   .ID_flush(ID_flush),
			   .EX_flush(EX_flush),
			   .PC_write(PCWrite),
			   .IFID_write(IFID_write)
);	


//Instantiate the components in EX stage

Shift_Left_Two_32 Shifter(
        .data_i(EX_extend_data),
        .data_o(shift_data)
);

MUX_3to1 #(.size(32)) MuxA( // Modify N, which is the total length of input/output
        .data0_i(EX_read_data1),
        .data1_i(Data),
        .data2_i(MEM_result),
        .select_i(selectA),
        .data_o(EX_op_data1)
);

MUX_3to1 #(.size(32)) MuxB( // Modify N, which is the total length of input/output
        .data0_i(EX_read_data2),
        .data1_i(Data),
        .data2_i(MEM_result),
        .select_i(selectB),
        .data_o(EX_op_data2)
);

MUX_2to1 #(.size(32)) Mux1( // Modify N, which is the total length of input/output
        .data0_i(EX_op_data2),
        .data1_i(EX_extend_data),
        .select_i(EX_ALUSrc),
        .data_o(srcData)
);

ALU ALU(
        .src1_i(EX_op_data1),
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
		
MUX_2to1 #(.size(5)) Mux2( // Modify N, which is the total length of input/output
        .data0_i(IDEX_rt),
        .data1_i(IDEX_rd),
        .select_i(EX_regDst),
        .data_o(EX_rd)
);

Adder Add_pc_branch(
        .src1_i(EX_seqAdd),
	    .src2_i(shift_data),
	    .sum_o(EX_branchAdd)   
);

MUX_2to1 #(.size(2)) Mux_WBFlush( // Modify N, which is the total length of input/output
        .data0_i({EX_regWrite, EX_memtoReg}),
        .data1_i(2'b0),
        .select_i(EX_flush),
        .data_o({EX_op_regWrite, EX_op_memtoReg})
);

MUX_2to1 #(.size(5)) Mux_MFlush( // Modify N, which is the total length of input/output
        .data0_i({EX_branch, EX_memRead, EX_memWrite, EX_btype}),
        .data1_i(5'b0),
        .select_i(EX_flush),
        .data_o({EX_op_branch, EX_op_memRead, EX_op_memWrite, EX_op_btype})
);

Forwarding FWunit(
			.EXMEM_regWrite(MEM_regWrite),
			.EXMEM_rD(MEM_rd),
            .MEMWB_regWrite(WB_regWrite),
            .MEMWB_rD(WB_rd),
            .IDEX_rS(IDEX_rs),
			.IDEX_rT(IDEX_rt),
			.ForwardA(selectA),
			.ForwardB(selectB)
);		

Pipe_Reg #(.size(109)) EX_MEM( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush(1'b0),
        .write(1'b1),
        .data_i({EX_op_regWrite, EX_op_memtoReg, EX_op_branch, EX_op_memRead, EX_op_memWrite, EX_op_btype, EX_branchAdd, EX_zero, EX_result, EX_op_data2, EX_rd}),
        .data_o({MEM_regWrite, MEM_memtoReg, MEM_branch, MEM_memRead, MEM_memWrite, MEM_btype, MEM_branchAdd, MEM_zero, MEM_result, MEM_read_data2, MEM_rd})
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

MUX_4to1 #(.size(1)) MuxBranch( // Modify N, which is the total length of input/output
        .data0_i(MEM_zero),
        .data1_i(~(MEM_zero | MEM_result[31])),
        .data2_i(~MEM_result[31]),
        .data3_i(~MEM_zero),
        .select_i(MEM_btype),
        .data_o(typeBranch)
);

Pipe_Reg #(.size(71)) MEM_WB( // Modify N, which is the total length of input/output
        .clk_i(clk_i),
        .rst_i(rst_i),
        .flush(1'b0),
        .write(1'b1),
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
