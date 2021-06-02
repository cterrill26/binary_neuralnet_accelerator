`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2021 12:13:09 AM
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
    input signed [WIDTH_IN-1:0] in0, in1, in2, in3,
    output logic signed [WIDTH_IN+2-1:0] out
);

    logic signed [WIDTH_IN:0] sum0, sum1;
    
    always_comb 
    begin
        sum0 = in0 + in1;
        sum1 = in2 + in3;
    end
    
    always_ff @ (posedge clk) 
    begin
        out <= sum0 + sum1;
    end
endmodule
