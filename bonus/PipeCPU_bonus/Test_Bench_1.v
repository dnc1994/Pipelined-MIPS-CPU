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

	$readmemb("testcase_1.txt", cpu.IM.Instr_Mem);
    #(`CYCLE_TIME/2)      RST = 1;
    #(`CYCLE_TIME*`END_COUNT)	$finish;
end

always@(posedge CLK) begin
    count = count + 1;
    // if (count >= 6 && count <= 13) begin
        
        // for(i=0; i<8; i=i+1) begin
            // $display("$%0d: %0d", i, cpu.RF.Reg_File[i]);
            //$display("$%0d: 0x%08x", i, cpu.RF.Reg_File[i]);
        // end
        // $display("$MUX_ALU_src1_w: %0d", cpu.MUX_ALU_src1_w);
        // $display("$MUX_ALU_src2_w: %0d", cpu.MUX_ALU_src2_w);
        // $display("$ALU_ret_w: %0d", cpu.ALU_ret_w);
        // $display("$EX_MEM_ALU_ret_w: %0d", cpu.EX_MEM_ALU_ret_w);
        
        // $display("$ID_EX_RegRs_w: %0d", cpu.ID_EX_RegRs_w);
        // $display("$ID_EX_RegRt_w: %0d", cpu.ID_EX_RegRt_w);
        // $display("$EX_MEM_RegRd_w: %0d", cpu.EX_MEM_RegRd_w);
        // $display("$MEM_WB_RegRd_w: %0d", cpu.MEM_WB_RegRd_w);
        // $display("$ForwardA: %0d", cpu.FU.ForwardA);
        // $display("$ForwardB: %0d", cpu.FU.ForwardB);
        
    // end

    // $display("\n");
    // $display("$cycle #%0d", count+1);

	if( count == `END_COUNT ) begin

		for(i=0; i<16; i=i+1) begin
			$display("$%0d: %0d", i, cpu.RF.Reg_File[i]);
            //$display("$%0d: 0x%08x", i, cpu.RF.Reg_File[i]);
		end
	end
end
  
endmodule
