`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2021 12:15:19 AM
// Design Name: 
// Module Name: add4
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


module add4
#(parameter WIDTH_IN = 8)
(
    input clk,
    input signed [WIDTH_IN+10:0] in [3:0],
    output logic signed [WIDTH_IN+10:0] out
);

    logic signed [WIDTH_IN+10:0] sum0, sum1;
    
    always_comb 
    begin
        sum0 = in[0] + in[1];
        sum1 = in[2] + in[3];
    end
    
    always_ff @ (posedge clk) 
    begin
        out <= sum0 + sum1;
    end
endmodule
