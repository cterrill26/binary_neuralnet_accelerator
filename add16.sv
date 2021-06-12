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


module add16
#(parameter WIDTH_IN = 8)
(
    input clk,
    input signed [WIDTH_IN+10:0] in[15:0],
    output logic signed [WIDTH_IN+10:0] out
);

    logic signed [WIDTH_IN+10:0] sum [3:0];
    
    generate
        for(genvar i=1; i<5; i++) begin: adder16
            add4 a4(
                .clk(clk),
                .in(in[4*i-1:4*i-4]),
                .out(sum[i-1])
            );        
        end
    endgenerate
    
    add4 a4(
        .clk(clk),
        .in(sum),
        .out(out)
    );

endmodule
