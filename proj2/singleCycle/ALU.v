//Subject:     Architecture project 2 - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
	src2_i,
	ctrl_i,
	result_o,
	zero_o
	);
     
//I/O ports
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
reg    [32-1:0]  result_o;
reg             zero_o;

//Parameter

//Main function
always @(src1_i, src2_i, ctrl_i) begin
    case (ctrl_i)
        // ADD
        4'b0010: result_o = src1_i + src2_i;
        // SUB
        4'b0110: result_o = src1_i - src2_i;
        // 
        4'b0000: result_o = src1_i & src2_i;
        4'b0001: result_o = src1_i | src2_i;
        4'b0111: begin
            if (src1_i[31] != src2_i[31]) begin
                if (src1_i[31] > src2_i[31]) begin
                    result_o = 1;
                end
                else begin
                    result_o = 0;    
                end
            end
            else begin
                if (src1_i < src2_i) begin
                    result_o = 1;
                end
                else begin
                    result_o = 0;    
                end
            end
        end
    endcase
    zero_o = (result_o == 0);
end

endmodule