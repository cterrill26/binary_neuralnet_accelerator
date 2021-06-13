`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/12/2021 04:04:37 PM
// Design Name: 
// Module Name: control_tb
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


module control_tb();

    logic clk, rst, start;
    logic idle;
    logic [15:0] load;
    logic [8:0] weight_addr_rd;
    logic [6:0] activation_addr_rd;
    logic [6:0] activation_addr_wr;
    logic [15:0] activation_enb_wr;
    logic [7:0] alpha_addr_rd; 
    
    control DUT
    (
        .clk(clk), 
        .rst(rst), 
        .start(start),
        .idle(idle),
        .load(load),
        .weight_addr_rd(weight_addr_rd),
        .activation_addr_rd(activation_addr_rd),
        .activation_addr_wr(activation_addr_wr),
        .activation_enb_wr(activation_enb_wr),
        .alpha_addr_rd(alpha_addr_rd )
    );

    always #5 clk = ~clk;
    
    
    initial 
    begin
        clk = 0;
        rst = 1;
        start = 0;
        #20;
        rst = 0;
        #200;
        start = 1;
        #10;
        start = 0;
        #50;
        wait(idle == 1);
        #50;
        $finish;
    end

endmodule
