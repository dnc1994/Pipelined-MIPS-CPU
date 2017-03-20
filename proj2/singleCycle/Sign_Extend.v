//Subject:     Architecture project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Zhang Linghao
//----------------------------------------------
//Date:        April 19th, 2016
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    data_o
    );

//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always@(data_i) begin
    data_o = { { 16{data_i[15]} }, { data_i[15:0] } };
end

endmodule