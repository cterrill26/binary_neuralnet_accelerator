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
#(parameter WIDTH_IN = 8)
(
    input clk, idle,
    input [15:0] load,
    input [8:0] weight_addr_rd,
    input [WIDTH_IN-1:0] activation_input,
    input [6:0] activation_addr_rd, activation_addr_wr,
    input [15:0] activation_enb_wr,
    input [7:0] alpha_addr_rd,
    output logic [15:0][WIDTH_IN-1:0] activation_output
);
     
    localparam HARD_TANH_MAX = 127;
    localparam HARD_TANH_MIN = -127;
    
    
    logic [255:0] weight_data_out; 
    logic [15:0][WIDTH_IN+10-1:0] accumulate_out;
    logic signed [WIDTH_IN+10-1:0] shift_out;
    logic [WIDTH_IN-1:0] activation_data_in;
    logic [15:0][WIDTH_IN-1:0] activation_data_out;
    logic [2:0] alpha_data_out;
    logic signed [WIDTH_IN-1:0] hard_tanh_out;
    
    assign activation_data_in = (idle)? activation_input : hard_tanh_out;
    
    rom_sp #(.RAM_WIDTH(256), .RAM_DEPTH(512), .INIT_FILE("weights.mem")) 
    weight_ram
    (
        .clk(clk),
        .addr_rd(weight_addr_rd),                          
        .data_out(weight_data_out) 
    );
    
    generate
        for(genvar i = 0; i < 16; i++) begin : ACTIVATION_RAM_ARRAY
            ram_dp #(.RAM_WIDTH(WIDTH_IN), .RAM_DEPTH(128))
            activation_ram
            (
                .clk(clk),
                .addr_wr(activation_addr_wr), 
                .addr_rd(activation_addr_rd), 
                .data_in(activation_data_in),         
                .enb_wr(activation_enb_wr[i]),                         
                .data_out(activation_data_out[i]) 
            );
        end 
    endgenerate   
    
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
                #(.WIDTH_IN(8))
                processing_element
                (
                    .clk(clk), 
                    .load(load[i]),
                    .weight(weight_data_out[i*16+:16]),
                    .activation(activation_data_out),
                    .accumulate_in(18'b0),
                    .accumulate_out(accumulate_out[i])
                );
            end
            else begin
                pe 
                #(.WIDTH_IN(8))
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
        shift_out <= $signed(accumulate_out[0]) >>> alpha_data_out;
        
        if(shift_out > HARD_TANH_MAX)
            hard_tanh_out <= HARD_TANH_MAX;
        else if (shift_out < HARD_TANH_MIN)   
            hard_tanh_out <= HARD_TANH_MIN; 
        else
            hard_tanh_out <= shift_out[WIDTH_IN-1:0];               
    end
    
    always_comb
    begin
        if(idle)
            activation_output = activation_data_out;
        else
        begin
            for(int i = 0; i < 16; i++)
                activation_output[i] = 0;
        end
    end
    
endmodule
