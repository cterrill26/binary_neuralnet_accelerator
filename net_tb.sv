`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 07:20:00 PM
// Design Name: 
// Module Name: net_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module net_tb;

reg clk;
reg rst;
wire [3:0] result;
wire [18:0] test_out;
net uut(
    .clk(clk),
    .rst(rst),
    .result(result),
    .test_out(test_out)
);
initial begin
clk = 0;
end
always #5 clk <= ~clk;


endmodule
