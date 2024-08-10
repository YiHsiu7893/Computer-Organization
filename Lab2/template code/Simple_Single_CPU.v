//Writer:      110550136
//----------------------------------------------
//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 04 / 18
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
`timescale 1ns/1ps
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire     [32-1:0] pc_in;
wire     [32-1:0] pc_out;
wire     [32-1:0] seqAdd;
wire     [32-1:0] instr_o;
wire     regDst;
wire     [5-1:0] write_reg1;
wire     [32-1:0] write_data;
wire     regWrite;
wire     [32-1:0] read_data1;
wire     [32-1:0] read_data2;
wire     [3-1:0] ALU_op;
wire     ALUSrc;
wire     branch;
wire     [4-1:0] ALUCtrl;
wire     [32-1:0] extend_data;
wire     [32-1:0] srcData;
wire     zero;
wire     [32-1:0] shift_data;
wire     [32-1:0] branchAdd;
wire 	 nextAdd = branch & zero;

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(pc_out),     
	    .sum_o(seqAdd)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr_o)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(regDst),
        .data_o(write_reg1)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(write_reg1) ,  
        .RDdata_i(write_data)  , 
        .RegWrite_i (regWrite),
        .RSdata_o(read_data1) ,  
        .RTdata_o(read_data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[31:26]), 
	    .RegWrite_o(regWrite), 
	    .ALU_op_o(ALU_op),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(regDst),   
		.Branch_o(branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instr_o[5:0]),   
        .ALUOp_i(ALU_op),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),       
        .data_o(extend_data)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data2),
        .data1_i(extend_data),
        .select_i(ALUSrc),
        .data_o(srcData)
        );	
		
ALU ALU(
        .src1_i(read_data1),
	    .src2_i(srcData),
	    .ctrl_i(ALUCtrl),
	    .result_o(write_data),
		.zero_o(zero)
	    );
		
Adder Adder2(
        .src1_i(seqAdd),     
	    .src2_i(shift_data),     
	    .sum_o(branchAdd)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(extend_data),
        .data_o(shift_data)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(seqAdd),
        .data1_i(branchAdd),
        .select_i(nextAdd),
        .data_o(pc_in)
        );	
endmodule