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
    input logic clk,
    input logic rst,
    output [3:0] result,
    output [18:0] test_out
    );
    //////////// SAMPLE ///////////////////
    reg [7:0] memory [9:0];
    integer   index;
    initial begin
        $readmemb("C:\\Users\\Freddy\\binarynet\\test.txt", memory);
        
        for(index = 0; index < 10; index = index + 1)
            $display("memory[%d] = %b", index[4:0], memory[index]);
    end
    //////////// END SAMPLE ///////////////////
    
    reg [INPUT_SIZE-1:0] input_weights [LAYER1-1:0];
    reg [LAYER1-1:0] layer1_weights [LAYER2-1:0];
    reg [LAYER2-1:0] layer2_weights [OUTPUT_SIZE-1:0];
       
    reg  [31:0] activations_l1 [LAYER1-1:0];
    reg  [31:0] activations_l2 [LAYER2-1:0];
    reg  [31:0] activations_out [OUTPUT_SIZE-1:0];
    //hidden layer 1
    //generate
    //Create processing elementa for each element in the second layer
    //    for (genvar i = 0; i < LAYER1; i=i+1) begin : L1_NEURON
            
        
    //    end
    
    //endgenerate
    
    
    
    logic signed [18:0] test[63:0];   
    initial begin
    for(int j = 0; j<64; j++) begin
        test[j] = -2;
    end
    end
    //output layer
    add64 a0(
        .clk(clk),
        .in(test),
        .out(test_out)
    );
    
    
endmodule
