`timescale 1ns / 1ps
// Subject:     Architecture Project1 - Simulator
// --------------------------------------------------------------------------------
// Version:     1
// --------------------------------------------------------------------------------
// Writer:      Zhang Linghao
// --------------------------------------------------------------------------------
// Date:        March 17th, 2016
// --------------------------------------------------------------------------------
// Description: 
// --------------------------------------------------------------------------------

module Simulator (
        clk_i,
		rst_i
);

// Parameter
`define INSTR_NUM 256
`define DATA_NUM 256

// R-type
`define ADD 6'h20
`define SUB 6'h22
`define AND 6'h24
`define OR 6'h25
`define SLT 6'h2a

// I-type
`define ADDI 6'h08
`define LW 6'h23
`define SW 6'h2B
`define SLTI 6'h0A
`define BEQ 6'h04

// I/O ports
input clk_i;
input rst_i;  

//DO NOT CHANGE SIZE, NAME
reg [32-1:0] Instr_Mem [0:`INSTR_NUM-1];
reg signed [32-1:0] Data_Mem [0:`DATA_NUM-1];
reg signed [32-1:0] Reg_File [0:32-1];

// Register
reg [32-1:0] instr;
reg [32-1:0] pc_addr;
reg [32-1:0] mem_addr;
reg [6-1:0] op;
reg [5-1:0] rs;
reg [5-1:0] rt;
reg [5-1:0] rd;
reg [5-1:0] shamt;
reg [6-1:0] func;
reg signed [32-1:0] immediate;
integer i;

// Decode Task
task decode_R;
	begin		
		rs = instr[25:21];
		rt = instr[20:16];
		rd = instr[15:11];
		shamt = instr[10:6];
		func = instr[5:0];
	end
endtask

task decode_I;
	begin
		rs = instr[25:21];
		rt = instr[20:16];
		immediate = {{16{instr[15]}}, instr[15:0]};
	end
endtask

// Main function
always @(posedge clk_i or negedge rst_i) begin
	if (rst_i == 0) begin
		for (i = 0; i < `DATA_NUM; i = i + 1)
			Data_Mem[i] = 32'd0;
		for (i = 0; i < 32; i = i + 1)
			Reg_File[i] = 32'd0;
		pc_addr = 32'd0;
	// Check instruction memory bound
	end
	else if (pc_addr / 4 < `INSTR_NUM) begin
		instr = Instr_Mem[pc_addr / 4];
		op = instr[31:26];
		if (op == 6'd0) begin // R-type
			decode_R;
			// Check if target register is $zero
			if (rd != 5'd0) begin
				case (func)
					`ADD: begin
						Reg_File[rd] = Reg_File[rs] + Reg_File[rt];
					end
					`SUB: begin
						Reg_File[rd] = Reg_File[rs] - Reg_File[rt];
					end
					`AND: begin
						Reg_File[rd] = Reg_File[rs] & Reg_File[rt];
					end
					`OR: begin
						Reg_File[rd] = Reg_File[rs] | Reg_File[rt];
					end
					`SLT: begin
						if (Reg_File[rs] < Reg_File[rt]) begin
							Reg_File[rd] = 32'd1;
						end else begin
							Reg_File[rd] = 32'd0;
						end
					end
				endcase
			end
		end
		else begin // I-type
			decode_I;
			// Prevent writing to $zero
			// $display("$Instruction: %b", instr);
			// $display("$PC: %d", pc_addr);
			//$display("$rt: %d0", rt);
			//$display("$rs: %d0", rs);
			// Check if target register is $zero
			if (rt != 5'd0) begin
				case (op)
					`ADDI: begin
						Reg_File[rt] = Reg_File[rs] + immediate;
					end
					`LW: begin
						// Address must be aligned
						if ((Reg_File[rs] + immediate) % 4 == 0) begin
							mem_addr = (Reg_File[rs] + immediate) / 4;
							// Check data memory bound
							if (mem_addr < `DATA_NUM) begin
								Reg_File[rt] = Data_Mem[mem_addr];
							end
						end
					end
					`SW: begin
						// Address must be aligned 						
						if ((Reg_File[rs] + immediate) % 4 == 0) begin
							mem_addr = (Reg_File[rs] + immediate) / 4;
							// Check data memory bound
							if (mem_addr < `DATA_NUM) begin
								Data_Mem[mem_addr] = Reg_File[rt];
							end
						end
					end
					`SLTI: begin
						if (Reg_File[rs] < immediate) begin
								Reg_File[rt] = 32'd1;
						end else begin
								Reg_File[rt] = 32'd0;
						end
					end
					`BEQ: begin
					    //$display("$BEQ:");
						//$display("$rt: %0d", Reg_File[rt]);
						//$display("$rs: %0d", Reg_File[rs]);
						//$display("$immediate: %0d", immediate);
						if (Reg_File[rt] == Reg_File[rs]) begin
							// $display("$Old PC: %d", pc_addr + 32'd4);
							// $display("$immediate: %d", immediate);
							// $display("$immediate * 4: %d", immediate * 32'd4);
							pc_addr = pc_addr + 32'd4 * immediate;
							// $display("$New PC: %d", pc_addr + 32'd4);
						end
					end
				endcase
			end
		end
		pc_addr = pc_addr + 32'd4;
	end
end

endmodule