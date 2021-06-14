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


module add128
#(parameter WIDTH_IN = 8)
(
    input clk,
    input signed [127:0][WIDTH_IN+10:0] in,
    output logic signed [WIDTH_IN+10:0] out
);

    logic signed [WIDTH_IN+10:0] sum0, sum1;
    
    add64 a0(
        .clk(clk),
        .in(in[127:64]),
        .out(sum0)
    );
    add64 a1(
        .clk(clk),
        .in(in[63:0]),
        .out(sum1)
    );

    always_ff @ (posedge clk) 
    begin
        out <= sum0 + sum1;
    end
endmodule
