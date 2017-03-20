`timescale 1ns / 1ps
//Subject:     Architecture project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Zhang Linghao
//----------------------------------------------
//Date:        April 19th, 2016
//----------------------------------------------
//Description: Structure for R-type
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
    clk_i,
	rst_i
);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signals
wire [32-1:0] mux_dataMem_result_w;
wire ctrl_register_write_w;
wire [32-1:0] pc_source_w;
wire [32-1:0] pc_addr_w;
wire [32-1:0] pc_addr_inc_w;
wire [32-1:0] instr_w;
wire ctrl_RegDst_w;
wire [5-1:0] mux_WriteReg_result_w;
wire [32-1:0] read_data_1_w;
wire [32-1:0] read_data_2_w;
wire [3-1:0] ctrl_ALUop_w;
wire ctrl_ALUsrc_w;
wire ctrl_Branch_w;
wire [32-1:0] imm_ext_w;
wire [32-1:0] mux_ALUSrc_result_w;
wire [32-1:0] ALU_result_w;
wire ALU_zero_w;
wire [32-1:0] imm_ext_sft_w;
wire [32-1:0] pc_addr_branch_w;
wire ctrl_MemRead_w;
wire ctrl_MemWrite_w;
wire ctrl_MemtoReg_w;
wire [4-1:0] ALUctrl_w;
wire [32-1:0] read_data_w;

//Create components
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_source_w),   
	    .pc_out_o(pc_addr_w) 
	    );
	
Adder Adder1(
        .src1_i(pc_addr_w),     
	    .src2_i(32'd4),     
	    .sum_o(pc_addr_inc_w)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_addr_w),  
	    .instr_o(instr_w)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_w[20:16]),
        .data1_i(instr_w[15:11]),
        .select_i(ctrl_RegDst_w),
        .data_o(mux_WriteReg_result_w)
        );	

//DO NOT MODIFY	.RDdata_i && .RegWrite_i
Reg_File RF(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.RSaddr_i(instr_w[25:21]),
		.RTaddr_i(instr_w[20:16]),
		.RDaddr_i(mux_WriteReg_result_w),
		.RDdata_i(mux_dataMem_result_w[31:0]),
		.RegWrite_i(ctrl_register_write_w),
		.RSdata_o(read_data_1_w),
		.RTdata_o(read_data_2_w)
        );
	
//DO NOT MODIFY	.RegWrite_o
Decoder Decoder(
        .instr_op_i(instr_w[31:26]), 
	    .RegWrite_o(ctrl_register_write_w), 
	    .ALU_op_o(ctrl_ALUop_w),   
	    .ALUSrc_o(ctrl_ALUsrc_w),   
	    .RegDst_o(ctrl_RegDst_w),   
		.Branch_o(ctrl_Branch_w),
        .MemWrite_o(ctrl_MemWrite_w),
        .MemRead_o(ctrl_MemRead_w),
        .MemtoReg_o(ctrl_MemtoReg_w)
	    );

ALU_Ctrl AC(
        .funct_i(instr_w[5:0]),   
        .ALUOp_i(ctrl_ALUop_w),   
        .ALUCtrl_o(ALUctrl_w) 
        );
	
Sign_Extend SE(
        .data_i(instr_w[15:0]),
        .data_o(imm_ext_w)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(read_data_2_w),
        .data1_i(imm_ext_w),
        .select_i(ctrl_ALUsrc_w),
        .data_o(mux_ALUSrc_result_w)
        );	
		
ALU ALU(
        .src1_i(read_data_1_w),
	    .src2_i(mux_ALUSrc_result_w),
	    .ctrl_i(ALUctrl_w),
	    .result_o(ALU_result_w),
		.zero_o(ALU_zero_w)
	    );
		
Adder Adder2(
        .src1_i(pc_addr_inc_w),     
	    .src2_i(imm_ext_sft_w),     
	    .sum_o(pc_addr_branch_w)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(imm_ext_w),
        .data_o(imm_ext_sft_w)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(pc_addr_inc_w),
        .data1_i(pc_addr_branch_w),
        .select_i(ctrl_Branch_w & ALU_zero_w),
        .data_o(pc_source_w)
        );	
		
Data_Memory DataMemory
 (
     .clk_i(clk_i),
     .rst_i(rst_i),
     .addr_i(ALU_result_w),
     .data_i(read_data_2_w),
     .MemRead_i(ctrl_MemRead_w),
     .MemWrite_i(ctrl_MemWrite_w),
     .data_o(read_data_w)
 );

//DO NOT MODIFY	.data_o
 MUX_2to1 #(.size(32)) Mux_DataMem_Read(
         .data0_i(ALU_result_w),
         .data1_i(read_data_w),
         .select_i(ctrl_MemtoReg_w),
         .data_o(mux_dataMem_result_w)
 );

endmodule