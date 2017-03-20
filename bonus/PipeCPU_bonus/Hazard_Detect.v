`timescale 1ns / 1ps

module HazardDetect(ID_EX_MemRead, ID_EX_RegRt, IF_ID_RegRs, IF_ID_RegRt, Stall);
input ID_EX_MemRead;
input [4:0] ID_EX_RegRt, IF_ID_RegRs, IF_ID_RegRt;
output Stall;
reg Stall;

always@(*)begin
    Stall = 1'b0;
    if (ID_EX_MemRead && (ID_EX_RegRt ==  IF_ID_RegRs || ID_EX_RegRt == IF_ID_RegRt))
    begin
        Stall = 1'b1;
    end
end

endmodule
