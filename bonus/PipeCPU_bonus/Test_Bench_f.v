//`timescale 1ns / 1ps
//Subject:     Architecture Project3 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Zhang Linghao
//----------------------------------------------
//Date:        April 19th, 2016
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

`define CYCLE_TIME 20			
`define END_COUNT 100
module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;

integer     f,i;
//Greate tested modle  
Pipe_CPU cpu(
        .clk_i(CLK),
		.rst_i(RST)
		);
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial  begin
	
	CLK = 1;
    RST = 0;
	count = 0;

	$readmemb("testcase_f.txt", cpu.IM.Instr_Mem);
    #(`CYCLE_TIME/2)      RST = 1;
    #(`CYCLE_TIME*`END_COUNT)	$finish;
end

always@(posedge CLK) begin
    count = count + 1;
    if (count <= 5) begin
        
        // for(i=0; i<8; i=i+1) begin
            // $display("$%0d: %0d", i, cpu.RF.Reg_File[i]);
            //$display("$%0d: 0x%08x", i, cpu.RF.Reg_File[i]);
        // end
        
        
        $display("$ID_EX_ALU_op_w: %0d", cpu.ID_EX_ALU_op_w);
        $display("$ALU_ctrl_w: %0d", cpu.ALU_ctrl_w);
        $display("$MUX_ALU_src1_w: %0d", cpu.MUX_ALU_src1_w);
        $display("$MUX_ALU_src2_w: %0d", cpu.MUX_ALU_src2_w);
        $display("$ALU_ret_w: %0d", cpu.ALU_ret_w);
        $display("$EX_MEM_ALU_ret_w: %0d", cpu.EX_MEM_ALU_ret_w);
        
        // $display("$ID_EX_RegRs_w: %0d", cpu.ID_EX_RegRs_w);
        // $display("$ID_EX_RegRt_w: %0d", cpu.ID_EX_RegRt_w);
        // $display("$EX_MEM_RegRd_w: %0d", cpu.EX_MEM_RegRd_w);
        // $display("$MEM_WB_RegRd_w: %0d", cpu.MEM_WB_RegRd_w);
        // $display("$ForwardA: %0d", cpu.FU.ForwardA);
        // $display("$ForwardB: %0d", cpu.FU.ForwardB);

        $display("INSTR: %0b ", cpu.MUX_IF_ID_instr_w);

        $display("BEQ? ", cpu.ctrl_Branch_w);
        $display("$PC_OLD = ", cpu.pc_old_w);
        $display("PC_BEQ_NOT_TAKEN = ", cpu.pc_plus_4_w);
        $display("PC_BEQ_TAKEN = ", cpu.pc_branch_taken_w);
        $display("$MUX_ALU_branch_src1_w = ", cpu.MUX_ALU_branch_src1_w);
        $display("$MUX_ALU_branch_src2_w = ", cpu.MUX_ALU_branch_src2_w);
        $display("$ALU_branch_ret_DC_w = ", cpu.ALU_branch_ret_DC_w);
        $display("$ALU_branch_zero_w = ", cpu.ALU_branch_zero_w);
        $display("BEQ TAKEN? ", cpu.ALU_branch_zero_w & cpu.ctrl_Branch_w);
        $display("STALL? ", cpu.stall_w);

        $display("\n");
        $display("$cycle #%0d", count+1);

    end

	if( count == `END_COUNT ) begin

		for(i=0; i<32; i=i+1) begin
			$display("$%0d: %0d", i, cpu.RF.Reg_File[i]);
            //$display("$%0d: 0x%08x", i, cpu.RF.Reg_File[i]);
		end
	end
end
  
endmodule
