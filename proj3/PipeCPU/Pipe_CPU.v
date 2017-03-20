`timescale 1ns / 1ps
/*******************************************************************
 * Create Date:     2016/05/03
 * Design Name:     Pipeline CPU
 * Module Name:     Pipe_CPU 
 * Project Name:    Architecture Project_3 Pipeline CPU
 
 * Please DO NOT change the module name, or your'll get ZERO point.
 * You should add your code here to complete the project 3.
 ******************************************************************/
module Pipe_CPU(
        clk_i,
        rst_i
        );

/****************************************
*            I/O ports                  *
****************************************/
input clk_i;
input rst_i;

/****************************************
*          Internal signal              *
****************************************/

/**** IF stage ****/
//control signal...
wire [31:0] pc_old_w;
wire [31:0] pc_new_w;
wire [31:0] pc_new_plus_4_w;
wire [31:0] instr_w;
wire [31:0] IF_ID_PC_new_plus_4_w;
wire [31:0] IF_ID_instr_w;
wire [31:0] MUX_IF_ID_PC_new_plus_4_w;
wire [31:0] MUX_IF_ID_instr_w;

/**** ID stage ****/
//control signal...
wire [2:0] ctrl_ALU_op_w;
wire ctrl_ALU_src_w;
wire ctrl_RegDst_w;
wire ctrl_Branch_w;
wire ctrl_MemWrite_w;
wire ctrl_MemRead_w;
wire ctrl_MemtoReg_w;
wire ctrl_RegWrite_w;
wire [31:0] RF_data1_w;
wire [31:0] RF_data2_w;
wire ID_EX_RegWrite_w;
wire ID_EX_MemtoReg_w;
wire ID_EX_Branch_w;
wire ID_EX_MemWrite_w;
wire ID_EX_MemRead_w;
wire ID_EX_RegDst_w;
wire [2:0] ID_EX_ALU_op_w;
wire ID_EX_ALU_src_w;
wire [31:0] ID_EX_RF_data1_w;
wire [31:0] ID_EX_RF_data2_w;
wire [4:0] ID_EX_RegRs_w;
wire [4:0]ID_EX_RegRt_w;
wire [4:0]ID_EX_RegRd_w;
wire [31:0] ID_EX_Imm_SE_w;
wire [31:0] imm_se_w;
wire [31:0] pc_branch_taken_w;
wire ALU_branch_zero_w;
wire [31:0] ALU_branch_ret_DC_w;
wire [31:0] MUX_ALU_branch_src1_w;
wire [31:0] MUX_ALU_branch_src2_w;

/**** EX stage ****/
//control signal...
wire [3:0] ALU_ctrl_w;
wire [31:0] ALU_ret_w;
wire ALU_zero_w;
wire [4:0] MUX_RegDst_w;
wire [31:0] MUX_ALU_src1_w;
wire [31:0] MUX_ALU_src2_pre_w;
wire [31:0] MUX_ALU_src2_w;
wire EX_MEM_RegWrite_w;
wire EX_MEM_MemtoReg_w;
wire EX_MEM_Branch_w;
wire EX_MEM_MemWrite_w;
wire EX_MEM_MemRead_w;
wire [31:0] EX_MEM_ALU_ret_w;
wire EX_MEM_ALU_zero_w;
wire [4:0] EX_MEM_RegRd_w;
wire [31:0] EX_MEM_DatatoWrite_w;
wire [31:0] imm_se_sft_w;

/**** MEM stage ****/
//control signal...
wire [31:0] DM_data_w;
wire MEM_WB_RegWrite_w;
wire MEM_WB_MemtoReg_w;
wire [31:0] MEM_WB_DM_data_w;
wire [31:0] MEM_WB_ALU_ret_w;
wire [4:0] MEM_WB_RegRd_w;


/**** WB stage ****/
//control signal...
wire [31:0] MUX_WB_w;


/**** Data hazard ****/
//control signal...
wire [1:0] forwardA_w;
wire [1:0] forwardB_w;
wire [1:0] forwardA2_w;
wire [1:0] forwardB2_w;

/****************************************
*       Instantiate modules             *
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i (rst_i),     
        .pc_in_i(pc_old_w),   
        .pc_out_o(pc_new_w) 
        );
            
Adder Add_pc(
        .src1_i(pc_new_w),     
        .src2_i(32'd4),     
        .sum_o(pc_new_plus_4_w)  
        );

MUX_2to1 #(.size(32)) MUX_PC(
        .data0_i(pc_new_plus_4_w),
        .data1_i(pc_branch_taken_w),
        .select_i(ALU_branch_zero_w & ctrl_Branch_w),
        .data_o(pc_old_w)
        );

Instr_Memory IM(
        .pc_addr_i(pc_new_w),
        .instr_o(instr_w)
        );

Pipe_Reg #(.size(32)) IF_ID_instr(       
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(MUX_IF_ID_instr_w),
        .data_o(IF_ID_instr_w)
        );

Pipe_Reg #(.size(32)) IF_ID_PC_new_plus_4(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(MUX_IF_ID_PC_new_plus_4_w),
        .data_o(IF_ID_PC_new_plus_4_w)
        );
        
// Use 2to1 MUX to flush IF stage registers (for BEQ)
MUX_2to1 #(.size(32)) MUX_IF_ID_instr(
        .data0_i(instr_w),
        .data1_i(32'd0),
        .select_i(ALU_branch_zero_w & ctrl_Branch_w),
        .data_o(MUX_IF_ID_instr_w)
        );

MUX_2to1 #(.size(32)) MUX_IF_ID_PC_new_plus_4(
        .data0_i(pc_new_plus_4_w),
        .data1_i(32'd0),
        .select_i(ALU_branch_zero_w & ctrl_Branch_w),
        .data_o(MUX_IF_ID_PC_new_plus_4_w)
        );

//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .RSaddr_i(IF_ID_instr_w[25:21]),
        .RTaddr_i(IF_ID_instr_w[20:16]),
        .RDaddr_i(MEM_WB_RegRd_w),
        .RDdata_i(MUX_WB_w),
        .RegWrite_i(MEM_WB_RegWrite_w),
        .RSdata_o(RF_data1_w),
        .RTdata_o(RF_data2_w)
        );

MUX_3to1 #(.size(32)) MUX_ALU_branch_src1(
        .data0_i(RF_data1_w),
        .data1_i(MUX_WB_w),
        .data2_i(EX_MEM_ALU_ret_w),
        .select_i(forwardA2_w),
        .data_o(MUX_ALU_branch_src1_w)
        );

MUX_3to1 #(.size(32)) MUX_ALU_branch_src2(
        .data0_i(RF_data2_w),
        .data1_i(MUX_WB_w),
        .data2_i(EX_MEM_ALU_ret_w),
        .select_i(forwardB2_w),
        .data_o(MUX_ALU_branch_src2_w)
        );

ALU ALU_branch(
        .src1_i(MUX_ALU_branch_src1_w),
        .src2_i(MUX_ALU_branch_src2_w),
        .ctrl_i(4'b0110),
        .result_o(ALU_branch_ret_DC_w),
        .zero_o(ALU_branch_zero_w)
        );

Decoder Control(
        .instr_op_i(IF_ID_instr_w[31:26]),
        .RegWrite_o(ctrl_RegWrite_w),
        .ALU_op_o(ctrl_ALU_op_w),
        .ALUSrc_o(ctrl_ALU_src_w),
        .RegDst_o(ctrl_RegDst_w),
        .Branch_o(ctrl_Branch_w),
        .MemWrite_o(ctrl_MemWrite_w),
        .MemRead_o(ctrl_MemRead_w),
        .MemtoReg_o(ctrl_MemtoReg_w)
        );

Sign_Extend Sign_Extend(
        .data_i(IF_ID_instr_w[15:0]),
        .data_o(imm_se_w)
        );  

Shift_Left_Two_32 Shift_Imm(
        .data_i(imm_se_w),
        .data_o(imm_se_sft_w)
        );

Adder Add_pc_branch_taken(
        .src1_i(IF_ID_PC_new_plus_4_w),     
        .src2_i(imm_se_sft_w),     
        .sum_o(pc_branch_taken_w)  
        );

Pipe_Reg #(.size(1)) ID_EX_RegWrite(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_RegWrite_w),
        .data_o(ID_EX_RegWrite_w)
        );

Pipe_Reg #(.size(1)) ID_EX_MemtoReg(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_MemtoReg_w),
        .data_o(ID_EX_MemtoReg_w)
        );

Pipe_Reg #(.size(1)) ID_EX_Branch(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_Branch_w),
        .data_o(ID_EX_Branch_w)
        );

Pipe_Reg #(.size(1)) ID_EX_MemWrite(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_MemWrite_w),
        .data_o(ID_EX_MemWrite_w)
        );

Pipe_Reg #(.size(1)) ID_EX_MemRead(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_MemRead_w),
        .data_o(ID_EX_MemRead_w)
        );

Pipe_Reg #(.size(1)) ID_EX_RegDst(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_RegDst_w),
        .data_o(ID_EX_RegDst_w)
        );

Pipe_Reg #(.size(3)) ID_EX_ALU_op(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_ALU_op_w),
        .data_o(ID_EX_ALU_op_w)
        );
        
Pipe_Reg #(.size(1)) ID_EX_ALU_src(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ctrl_ALU_src_w),
        .data_o(ID_EX_ALU_src_w)
        );

Pipe_Reg #(.size(32)) ID_EX_RF_data1(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(RF_data1_w),
        .data_o(ID_EX_RF_data1_w)
        );

Pipe_Reg #(.size(32)) ID_EX_RF_data2(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(RF_data2_w),
        .data_o(ID_EX_RF_data2_w)
        );

Pipe_Reg #(.size(5)) ID_EX_RegRs(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(IF_ID_instr_w[25:21]),
        .data_o(ID_EX_RegRs_w)
        );

Pipe_Reg #(.size(5)) ID_EX_RegRt(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(IF_ID_instr_w[20:16]),
        .data_o(ID_EX_RegRt_w)
        );

Pipe_Reg #(.size(5)) ID_EX_RegRd(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(IF_ID_instr_w[15:11]),
        .data_o(ID_EX_RegRd_w)
        );

Pipe_Reg #(.size(32)) ID_EX_Imm_SE(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(imm_se_w),
        .data_o(ID_EX_Imm_SE_w)
        );

//Instantiate the components in EX stage
ALU ALU(
        .src1_i(MUX_ALU_src1_w),
        .src2_i(MUX_ALU_src2_w),
        .ctrl_i(ALU_ctrl_w),
        .result_o(ALU_ret_w),
        .zero_o(ALU_zero_w)
        );
        
ALU_Ctrl ALU_Control(
        .funct_i(ID_EX_Imm_SE_w[5:0]),
        .ALUOp_i(ID_EX_ALU_op_w),
        .ALUCtrl_o(ALU_ctrl_w)
        );

MUX_2to1 #(.size(5)) MUX_RegDst(
        .data0_i(ID_EX_RegRt_w),
        .data1_i(ID_EX_RegRd_w),
        .select_i(ID_EX_RegDst_w),
        .data_o(MUX_RegDst_w)
        );

MUX_3to1 #(.size(32)) Mux_ALU_src1(
        .data0_i(ID_EX_RF_data1_w),
        .data1_i(MUX_WB_w),
        .data2_i(EX_MEM_ALU_ret_w),
        .select_i(forwardA_w),
        .data_o(MUX_ALU_src1_w)
        );
        
MUX_3to1 #(.size(32)) Mux_ALU_src2_pre(
        .data0_i(ID_EX_RF_data2_w),
        .data1_i(MUX_WB_w),
        .data2_i(EX_MEM_ALU_ret_w),
        .select_i(forwardB_w),
        .data_o(MUX_ALU_src2_pre_w)
        );

MUX_2to1 #(.size(32)) Mux_ALU_src2(
        .data0_i(MUX_ALU_src2_pre_w),
        .data1_i(ID_EX_Imm_SE_w),
        .select_i(ID_EX_ALU_src_w),
        .data_o(MUX_ALU_src2_w)
        );

Pipe_Reg #(.size(1)) EX_MEM_RegWrite(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ID_EX_RegWrite_w),
        .data_o(EX_MEM_RegWrite_w)
        );

Pipe_Reg #(.size(1)) EX_MEM_MemtoReg(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ID_EX_MemtoReg_w),
        .data_o(EX_MEM_MemtoReg_w)
        );

Pipe_Reg #(.size(1)) EX_MEM_Branch(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ID_EX_Branch_w),
        .data_o(EX_MEM_Branch_w)
        );

Pipe_Reg #(.size(1)) EX_MEM_MemWrite(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ID_EX_MemWrite_w),
        .data_o(EX_MEM_MemWrite_w)
        );

Pipe_Reg #(.size(1)) EX_MEM_MemRead(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ID_EX_MemRead_w),
        .data_o(EX_MEM_MemRead_w)
        );

Pipe_Reg #(.size(32)) EX_MEM_ALU_ret(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ALU_ret_w),
        .data_o(EX_MEM_ALU_ret_w)
        );

Pipe_Reg #(.size(1)) EX_MEM_ALU_zero(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(ALU_zero_w),
        .data_o(EX_MEM_ALU_zero_w)
        );

Pipe_Reg #(.size(5)) EX_MEM_RegRd(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(MUX_RegDst_w),
        .data_o(EX_MEM_RegRd_w)
        );

Pipe_Reg #(.size(32)) EX_MEM_DatatoWrite(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(MUX_ALU_src2_pre_w),
        .data_o(EX_MEM_DatatoWrite_w)
        );

//Instantiate the components in MEM stage
Data_Memory DM(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .addr_i(EX_MEM_ALU_ret_w),
        .data_i(EX_MEM_DatatoWrite_w),
        .MemRead_i(EX_MEM_MemRead_w),
        .MemWrite_i(EX_MEM_MemWrite_w),
        .data_o(DM_data_w)
        );

Pipe_Reg #(.size(1)) MEM_WB_RegWrite(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(EX_MEM_RegWrite_w),
        .data_o(MEM_WB_RegWrite_w)
        );

Pipe_Reg #(.size(1)) MEM_WB_MemtoReg(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(EX_MEM_MemtoReg_w),
        .data_o(MEM_WB_MemtoReg_w)
        );

Pipe_Reg #(.size(32)) MEM_WB_DM_data(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(DM_data_w),
        .data_o(MEM_WB_DM_data_w)
        );

Pipe_Reg #(.size(32)) MEM_WB_ALU_ret(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(EX_MEM_ALU_ret_w),
        .data_o(MEM_WB_ALU_ret_w)
        );

Pipe_Reg #(.size(5)) MEM_WB_RegRd(
        .rst_i(rst_i),
        .clk_i(clk_i),
        .data_i(EX_MEM_RegRd_w),
        .data_o(MEM_WB_RegRd_w)
        );

//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux_WB(
        .data0_i(MEM_WB_ALU_ret_w),
        .data1_i(MEM_WB_DM_data_w),
        .select_i(MEM_WB_MemtoReg_w),
        .data_o(MUX_WB_w)
        );

//Instantiate forwarding unit
ForwardinUnit FU(
        .EX_MEMRegWrite(EX_MEM_RegWrite_w),
        .MEM_WBRegWrite(MEM_WB_RegWrite_w),
        .EX_MEMRegisterRd(EX_MEM_RegRd_w),
        .MEM_WBRegisterRd(MEM_WB_RegRd_w),
        .ID_EXRegisterRs(ID_EX_RegRs_w),
        .ID_EXRegisterRt(ID_EX_RegRt_w),
        .ForwardA(forwardA_w),
        .ForwardB(forwardB_w)
        );

ForwardinUnit FU2(
        .EX_MEMRegWrite(EX_MEM_RegWrite_w),
        .MEM_WBRegWrite(MEM_WB_RegWrite_w),
        .EX_MEMRegisterRd(EX_MEM_RegRd_w),
        .MEM_WBRegisterRd(MEM_WB_RegRd_w),
        .ID_EXRegisterRs(IF_ID_instr_w[25:21]),
        .ID_EXRegisterRt(IF_ID_instr_w[20:16]),
        .ForwardA(forwardA2_w),
        .ForwardB(forwardB2_w)
        );

/****************************************
*         Signal assignment             *
****************************************/

endmodule
