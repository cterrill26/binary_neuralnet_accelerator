`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 10:46:07 PM
// Design Name: 
// Module Name: bnn
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


module bnn(
    input clk, rst, start, activation_input_enb_wr, 
    input [2:0] beta_in,
    input [15:0] activation_input_data,
    input [6:0] activation_input_addr_rd, activation_input_addr_wr,
    output [15:0] activation_out,
    output done
);
    
    logic idle;
    logic [15:0] load;
    logic [8:0] weight_addr_rd;
    logic [6:0] activation_addr_rd, activation_addr_wr;
    logic [15:0] activation_enb_wr;
    logic [6:0] control_activation_addr_rd, control_activation_addr_wr;
    logic [15:0] control_activation_enb_wr;
    logic [7:0] alpha_addr_rd;
    logic [3:0] sum_shift;
    logic sum_enb, beta_enb;
    
    logic [15:0] activation_input_data_reg;
    logic [6:0] activation_input_addr_rd_reg, activation_input_addr_wr_reg;
    logic activation_input_enb_wr_reg;
    
    datapath d
    (
        .clk(clk), 
        .idle(idle),
        .load(load),
        .weight_addr_rd(weight_addr_rd),
        .activation_input(activation_input_data_reg),
        .beta_in(beta_in),
        .sum_shift(sum_shift),
        .sum_enb(sum_enb), 
        .beta_enb(beta_enb),
        .activation_addr_rd(activation_addr_rd), 
        .activation_addr_wr(activation_addr_wr),
        .activation_enb_wr(activation_enb_wr),
        .alpha_addr_rd(alpha_addr_rd),
        .activation_output(activation_out)
    );
    
    control c
    (
        .clk(clk), 
        .rst(rst), 
        .start(start),
        .idle(idle),
        .load(load),
        .sum_shift(sum_shift),
        .sum_enb(sum_enb), 
        .beta_enb(beta_enb),
        .weight_addr_rd(weight_addr_rd),
        .activation_addr_rd(control_activation_addr_rd), 
        .activation_addr_wr(control_activation_addr_wr),
        .activation_enb_wr(control_activation_enb_wr),
        .alpha_addr_rd(alpha_addr_rd) 
    );    
    
    assign done = idle;
       
    
    always_ff @ (posedge clk)
    begin
        activation_input_data_reg <= activation_input_data;
        activation_input_addr_rd_reg <= activation_input_addr_rd;
        activation_input_addr_wr_reg <= activation_input_addr_wr;
        activation_input_enb_wr_reg <= activation_input_enb_wr;                           
    end
    
    always_comb
    begin
        if(idle) begin
            activation_addr_rd = activation_input_addr_rd_reg;
            activation_addr_wr = activation_input_addr_wr_reg;
            activation_enb_wr = {16{activation_input_enb_wr_reg}};
        end
        else begin
            activation_addr_rd = control_activation_addr_rd;
            activation_addr_wr = control_activation_addr_wr;
            activation_enb_wr = control_activation_enb_wr;
        end
    end
endmodule
