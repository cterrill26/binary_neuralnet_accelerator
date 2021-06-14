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


module add784
#(parameter WIDTH_IN = 8)
(
    input clk,
    input signed [783:0][WIDTH_IN+10:0] in,
    output logic signed [WIDTH_IN+10:0] out
);

    logic signed [WIDTH_IN+10:0] sum0, sum1, sum2, sum3, sum;
    
    add256 a0(
        .clk(clk),
        .in(in[783:528]),
        .out(sum0)
    );
    add256 a1(
        .clk(clk),
        .in(in[527:272]),
        .out(sum1)
    );
    add256 a2(
        .clk(clk),
        .in(in[271:16]),
        .out(sum2)
    );
    add16 a3(
        .clk(clk),
        .in(in[15:0]),
        .out(sum3)
    );
    
    add4 a4(
        .clk(clk),
        .in({sum0,sum1,sum2,sum3}),
        .out(out)
    );
    
 
endmodule
