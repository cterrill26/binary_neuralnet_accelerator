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


module add64
#(parameter WIDTH_IN = 8)
(
    input clk,
    input signed [63:0][WIDTH_IN+10:0] in,
    output logic signed [WIDTH_IN+10:0] out
);

    logic signed [3:0][WIDTH_IN+10:0] sum ;
    
    generate
        for(genvar i=1; i<5; i++) begin: adder64
            add16 a16(
                .clk(clk),
                .in(in[16*i-1:16*i-16]),
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
