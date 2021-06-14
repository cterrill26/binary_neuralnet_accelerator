`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2021 12:28:09 AM
// Design Name: 
// Module Name: neuron_l1
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


module neuron_out
#(parameter WIDTH_IN = 8)
    (
    input clk,
    input [63:0][WIDTH_IN-1:0] activations ,
    input [63:0] weights,
    input [4:0] alpha,
    output logic signed [WIDTH_IN+-1:0] accumulated_result
    );
    
    logic [63:0][WIDTH_IN+10:0] products ;
    logic signed [WIDTH_IN+10:0] sum;
    
    //multiply the activations by weights
    always_comb begin
        for (int i=0; i<64; i++) begin
            products[i] = activations[i];
            if (~weights[i]) 
                products[i] = -activations[i];
        end
    end
    
    //add up all the activations
    add64 addL1(
        .clk(clk),
        .in(products),
        .out(sum)
    );
    
    always_ff @(posedge clk) begin
        if (sum>>alpha > 127)
            accumulated_result <= 127;
        else if(sum>>alpha < -127)
            accumulated_result <= -127;
        else
            accumulated_result <= sum>>alpha ;
    end
endmodule
