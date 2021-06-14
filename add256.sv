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


module add256
#(parameter WIDTH_IN = 8)
(
    input clk,
    input signed [255:0][WIDTH_IN+10:0] in,
    output logic signed [WIDTH_IN+10:0] out
);

    logic signed [WIDTH_IN+10:0] sum0, sum1, sum2, sum3, sum;
    
    add64 a0(
        .clk(clk),
        .in(in[255:192]),
        .out(sum0)
    );
    add64 a1(
        .clk(clk),
        .in(in[191:128]),
        .out(sum1)
    );
    add64 a2(
        .clk(clk),
        .in(in[127:64]),
        .out(sum2)
    );
    add64 a3(
        .clk(clk),
        .in(in[63:0]),
        .out(sum3)
    );
    
    add4 a4(
        .clk(clk),
        .in({sum0,sum1,sum2,sum3}),
        .out(out)
    );

endmodule
