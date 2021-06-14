`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 01:27:14 AM
// Design Name: 
// Module Name: net
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


module net #(
    parameter INPUT_SIZE = 784, 
    parameter LAYER1 = 128,
    parameter LAYER2 = 64,
    parameter OUTPUT_SIZE = 10)    
(
    input clk,
    input logic rst,
    output [3:0] result,
    output [18:0] test_out,
    output [OUTPUT_SIZE-1:0][7:0] activations_out
    );
    `include "C:/Users/Freddy/bnn2/bnn2.srcs/sources_1/imports/weights.sv"  
    `include "C:/Users/Freddy/bnn2/bnn2.srcs/sources_1/imports/activations.sv"     

    logic signed  [LAYER1-1:0][7:0] activations_l1 ;
    logic signed  [LAYER2-1:0][7:0] activations_l2 ;
    
    //hidden layer 1
    generate
    //Create processing elementa for each neuron in the first layer
        for (genvar i = 0; i < LAYER1; i=i+1) begin : L1_NEURON 
            neuron_l1 n1(
                .clk(clk),
                .activations(activations_in),
                .weights(input_weights[i]),
                .alpha(alpha1[i]),
                .accumulated_result(activations_l1[i])
            );
        end
    endgenerate
    
    generate
    //Create processing elementa for each element in the second layer
        for (genvar j = 0; j < LAYER2; j=j+1) begin : L2_NEURON 
            neuron_l2 n2(
            .clk(clk),
                .activations(activations_l1),
                .weights(l1_weights[j]),
                .alpha(alpha2[j]),
                .accumulated_result(activations_l2[j])
            );
        end
    endgenerate

    
    
    generate
    //Create processing elementa for each element in the output layer
        for (genvar k = 0; k < OUTPUT_SIZE; k=k+1) begin : OUT_NEURON 
            neuron_out n3(
            .clk(clk),
                .activations(activations_l2),
                .weights(out_weights[k]),
                .alpha(alpha3[k]),
                .accumulated_result(activations_out[k])
            );
        end
    endgenerate
    
    
    //ADDER TESTING
    logic signed [127:0][18:0] test;   
    initial begin
    for(int j = 0; j<128; j++) begin
        test[j] = 1;
    end
    end
    //output layer
    add128 a0(
        .clk(clk),
        .in(test),
        .out(test_out)
    );
endmodule
