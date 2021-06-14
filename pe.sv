`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2021 12:12:38 AM
// Design Name: 
// Module Name: pe
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


module pe
(
    input clk, load,
    input [15:0] weight,
    input [15:0] activation,
    input [10:0] accumulate_in,
    output [10:0] accumulate_out
);

    logic signed [10:0] accumulate; //allow sums to grow to 10 bits
    
    logic [15:0] product;
    logic [3:0][2:0] sum0;
    logic [4:0] sum1;
    
    assign product = weight ~^ activation;
    
    always_ff @ (posedge clk)
    begin
        for(int i = 0; i < 4; i++)
        begin
            sum0[i] <= product[4*i] + product[4*i+1] + product[4*i+2] + product[4*i+3];        
        end
    end
    
    add4 
    #(.WIDTH_IN(3))
    addstage1
    (
        .clk(clk),
        .in0(sum0[0]),
        .in1(sum0[1]),
        .in2(sum0[2]),
        .in3(sum0[3]),
        .out(sum1)
    );
    
    always_ff @ (posedge clk)
    begin
        if(load)
            accumulate <= accumulate_in;
        else
            accumulate <= accumulate + 2*($signed({1'b0, sum1}) - 8);
    end

    assign accumulate_out = accumulate;

endmodule
