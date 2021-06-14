`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2021 07:39:52 PM
// Design Name: 
// Module Name: bnn_tb
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


module bnn_tb();
    
    logic clk, rst, start, activation_input_enb_wr;
    logic [2:0] beta_in;
    logic [15:0] activation_input_data;
    logic [6:0] activation_input_addr_rd, activation_input_addr_wr;
    logic [15:0] activation_out;
    logic done;
    
    logic [15:0] image [48:0];
    initial
        $readmemb("image.mem", image, 0, 48);
    
    bnn DUT
    (
        .clk(clk),
        .rst(rst),
        .start(start),
        .beta_in(beta_in),
        .activation_input_enb_wr(activation_input_enb_wr),
        .activation_input_data(activation_input_data),
        .activation_input_addr_rd(activation_input_addr_rd),
        .activation_input_addr_wr(activation_input_addr_wr),
        .activation_out(activation_out),
        .done(done)
    );
    
    
    always #1 clk = ~clk;
    
    
    initial 
    begin
        clk = 0;
        rst = 1;
        start = 0;
        beta_in = 1; 
        activation_input_enb_wr = 0;
        activation_input_data = 0;
        activation_input_addr_rd = 0;
        activation_input_addr_wr = 0;
        #4;
        rst = 0;
        #40;
        activation_input_enb_wr = 1;
        for(int i = 0; i < 49; i++)
        begin
            activation_input_data = image[i];
            activation_input_addr_wr = i;
            #2;
        end
        activation_input_enb_wr = 0;
        activation_input_data = 0;
        activation_input_addr_wr = 0;
        #20;
        start = 1;
        #4;
        start = 0;
        #10;
        wait(done == 1);
        #10;
        activation_input_addr_rd = 64;
        #20;
        $display("%b", activation_out[9:0]);
        $finish;    
    end
    
endmodule
