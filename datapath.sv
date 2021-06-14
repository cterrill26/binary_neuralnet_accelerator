`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 10:44:06 PM
// Design Name: 
// Module Name: datapath
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


module datapath
(
    input clk, idle,
    input [15:0] load,
    input [8:0] weight_addr_rd,
    input [15:0] activation_input,
    input [2:0] beta_in,
    input [3:0] sum_shift,
    input sum_enb,
    input beta_enb,
    input [6:0] activation_addr_rd, activation_addr_wr,
    input [15:0] activation_enb_wr,
    input [7:0] alpha_addr_rd,
    output logic [15:0] activation_output
);
     
    localparam HARD_TANH_MAX = 127;
    localparam HARD_TANH_MIN = -127;
    
    
    logic [255:0] weight_data_out; 
    logic [15:0][10:0] accumulate_out;
    logic signed [10:0] shift_out;
    logic [15:0] activation_data_in;
    logic [15:0] activation_data_out;
    logic [2:0] alpha_data_out;
    logic signed [7:0] hard_tanh_out;
    logic [2:0] beta;
    logic [17:0] sum;
    logic beta_enb_reg;
    
    assign activation_data_in = (idle)? activation_input : {16{hard_tanh_out[7]}};
    
    rom_sp #(.RAM_WIDTH(256), .RAM_DEPTH(512), .INIT_FILE("weights.mem")) 
    weight_ram
    (
        .clk(clk),
        .addr_rd(weight_addr_rd),                          
        .data_out(weight_data_out) 
    );  
    
    ram_dp #(.RAM_WIDTH(16), .RAM_DEPTH(128))
    activation_ram
    (
        .clk(clk),
        .addr_wr(activation_addr_wr), 
        .addr_rd(activation_addr_rd), 
        .data_in(activation_data_in),         
        .enb_wr(activation_enb_wr),                         
        .data_out(activation_data_out) 
    ); 
    
    rom_sp #(.RAM_WIDTH(3), .RAM_DEPTH(256), .INIT_FILE("alphas.mem")) 
    alpha_ram
    (
        .clk(clk),
        .addr_rd(alpha_addr_rd),                           
        .data_out(alpha_data_out) 
    );            

    generate
        for (genvar i = 0; i < 16; i++) begin : PE_ARRAY
            if(i == 15) begin
                pe 
                processing_element
                (
                    .clk(clk), 
                    .load(load[i]),
                    .weight(weight_data_out[i*16+:16]),
                    .activation(activation_data_out),
                    .accumulate_in(11'b0),
                    .accumulate_out(accumulate_out[i])
                );
            end
            else begin
                pe 
                processing_element
                (
                    .clk(clk), 
                    .load(load[i]),
                    .weight(weight_data_out[i*16+:16]),
                    .activation(activation_data_out),
                    .accumulate_in(accumulate_out[i+1]),
                    .accumulate_out(accumulate_out[i])
                );
            end       
        end
    endgenerate 
    
    
    always_ff @ (posedge clk) 
    begin
        shift_out <= $signed(accumulate_out[0]) >>> (alpha_data_out + beta);
        
        if(shift_out > HARD_TANH_MAX)
            hard_tanh_out <= HARD_TANH_MAX;
        else if (shift_out < HARD_TANH_MIN)   
            hard_tanh_out <= HARD_TANH_MIN; 
        else
            hard_tanh_out <= shift_out[7:0];               
    end
    
    always_comb
    begin
        if(idle)
            activation_output = activation_data_out;
        else
            activation_output = 0;       
    end
    
    always_ff @ (posedge clk) 
    begin
        beta_enb_reg <= beta_enb;
        
        if (sum_enb)
            sum <= sum + (hard_tanh_out[7])? -hard_tanh_out : hard_tanh_out;
        else if(beta_enb)
            sum <= 0;
        else
            sum <= sum;
            
        if(idle)
            beta <= beta_in;
        else if(beta_enb && !beta_enb_reg) begin
            case(sum[sum_shift+:7]) inside
            7'b1??????: beta <= 1;
            7'b?1?????: beta <= 2;
            7'b??1????: beta <= 3;
            7'b???1???: beta <= 4;
            7'b????1??: beta <= 5;
            7'b?????1?: beta <= 6;
            7'b??????1, 7'b0000000: beta <= 7;
            endcase
        end
        else
            beta <= beta;
            
    end
    
endmodule
