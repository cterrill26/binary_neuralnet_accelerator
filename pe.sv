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
#(parameter WIDTH_IN = 8)
(
    input clk, load,
    input [15:0] weight,
    input [15:0][WIDTH_IN-1:0] activation,
    input [WIDTH_IN+10-1:0] accumulate_in,
    output [WIDTH_IN+10-1:0] accumulate_out
);

    logic signed [WIDTH_IN+10-1:0] accumulate; //allow sums to grow 10 bits
    
    logic [15:0][WIDTH_IN-1:0] product;
    logic [3:0][WIDTH_IN+2-1:0] sum0;
    logic [WIDTH_IN+4-1:0] sum1;
    
    always_comb 
    begin
        for(int i = 0; i < 16; i++)
        begin
            product[i] = activation[i];  
            if(weight[i]) //weight value of 1 signifies negative number 
                product[i] = -activation[i];               
        end
    end
    
    generate
        for(genvar i = 0; i < 4; i++) begin : ADDSTAGE0
            add4 
            #(.WIDTH_IN(WIDTH_IN))
            addstage0
            (
                .clk(clk),
                .in0(product[4*i+0]),
                .in1(product[4*i+1]),
                .in2(product[4*i+2]),
                .in3(product[4*i+3]),
                .out(sum0[i])
            );
        end
    endgenerate 
    
    add4 
    #(.WIDTH_IN(WIDTH_IN+2))
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
            accumulate <= accumulate + $signed(sum1);
    end

    assign accumulate_out = accumulate;

endmodule
