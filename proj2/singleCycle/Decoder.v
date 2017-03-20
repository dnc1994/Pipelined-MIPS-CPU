//Subject:     Architecture project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Zhang Linghao
//----------------------------------------------
//Date:        April 19th, 2016
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
    MemRead_o,
    MemtoReg_o,
    MemWrite_o,
	);
     
// I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemRead_o;
output         MemtoReg_o;
output         MemWrite_o;

// Internal Signals
reg         RegWrite_o;
reg [3-1:0] ALU_op_o;
reg         ALUSrc_o;
reg         RegDst_o;
reg         Branch_o;
reg         MemRead_o;
reg         MemtoReg_o;
reg         MemWrite_o;

// Parameter

// Main function
always @(instr_op_i) begin
    ALU_op_o = 3'b010;
    ALUSrc_o = 1'b0;
    Branch_o = 1'b0;
    MemRead_o = 1'b0;
    MemtoReg_o = 1'b0;
    MemWrite_o = 1'b0;
    RegDst_o = 1'b1;
    RegWrite_o = 1'b1;

    case (instr_op_i)
        // lw
        6'b100011: begin
            ALU_op_o = 3'b000;
            ALUSrc_o = 1'b1;
            MemRead_o = 1'b1;
            MemtoReg_o = 1'b1;
            RegDst_o = 1'b0;    
        end
        // sw
        6'b101011: begin
            ALU_op_o = 3'b000;
            ALUSrc_o = 1'b1;
            MemWrite_o = 1'b1;
            RegWrite_o = 1'b0;
        end
        // beq
        6'b000100: begin
            ALU_op_o = 3'b001;
            Branch_o = 1'b1;
            RegWrite_o = 1'b0;
        end
        // addi
        6'b001000: begin
            ALU_op_o = 3'b000;
            ALUSrc_o = 1'b1;
            RegDst_o = 1'b0;
        end
        // slti
        6'b001010: begin
            ALU_op_o = 3'b011;
            ALUSrc_o = 1'b1;
            RegDst_o = 1'b0;
        end
    endcase
end

endmodule