//Writer:      YiHsiu
//----------------------------------------------
//Subject:     CO project 3 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Date:        2023 / 04 / 26
//----------------------------------------------
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
wire     [28-1:0] jumpAdd_tmp;
wire     [1:0] regDst;
wire     [5-1:0] write_reg;
wire     [32-1:0] write_data;
wire     regWrite;
wire     [32-1:0] read_data1;
wire     [32-1:0] read_data2;
wire     [3-1:0] ALU_op;
wire     ALUSrc;
wire     branch;
wire     jump;
wire     memRead;
wire     memWrite;
wire     [1:0] memtoReg;
wire     [4-1:0] ALUCtrl;
wire     [32-1:0] extend_data;
wire     [32-1:0] srcData;
wire     [32-1:0] result;
wire     zero;
wire     [32-1:0] memData;
wire     [32-1:0] shift_data;
wire     [32-1:0] branchAdd;
//wire     jr_ctr = ALU_op[1] & ~instr_o[5];
wire     jr_ctr = (ALU_op[2] & ALU_op[1] & ~ALU_op[0]) & (~instr_o[5] & ~instr_o[4] & instr_o[3] & ~instr_o[2] & ~instr_o[1] & ~instr_o[0]);
wire 	 nextAdd = branch & zero;
wire     [32-1:0] pc_tmp;
wire     [32-1:0] jumpAdd = {seqAdd[31:28],jumpAdd_tmp[27:0]};

//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(seqAdd)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr_o)    
	    );
	    
Shift_Left_Two_32 #(.size(28)) Shifter1(
        .data_i({2'b00,instr_o[25:0]}),
        .data_o(jumpAdd_tmp)
        );

MUX_3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .data2_i(5'b11111),
        .select_i(regDst),
        .data_o(write_reg)
        );	
		
Reg_File Registers(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(write_reg) ,  
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
		.Branch_o(branch),
		.Jump_o(jump),
        .MemRead_o(memRead),
        .MemWrite_o(memWrite),
        .MemtoReg_o(memtoReg)   
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
	    .result_o(result),
		.zero_o(zero)
	    );
	
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(result),
	.data_i(read_data2),
	.MemRead_i(memRead),
	.MemWrite_i(memWrite),
	.data_o(memData)
	);

MUX_3to1 #(.size(32)) Mux_Write_Data(
        .data0_i(result),
        .data1_i(memData),
        .data2_i(seqAdd),
        .select_i(memtoReg),
        .data_o(write_data)
        );	
        	
Adder Adder2(
        .src1_i(seqAdd),     
	    .src2_i(shift_data),     
	    .sum_o(branchAdd)      
	    );
		
Shift_Left_Two_32 #(.size(32)) Shifter2(
        .data_i(extend_data),
        .data_o(shift_data)
        ); 		
        
MUX_3to1 #(.size(32)) Mux_PC_Source(
        .data0_i(seqAdd),
        .data1_i(branchAdd),
        .data2_i(read_data1),
        .select_i({jr_ctr,nextAdd}),
        .data_o(pc_tmp)
        );	
        
MUX_2to1 #(.size(32)) Mux_PC_Jump(
       .data0_i(pc_tmp),
       .data1_i(jumpAdd),
       .select_i(jump),
       .data_o(pc_in)
       );	
endmodule
