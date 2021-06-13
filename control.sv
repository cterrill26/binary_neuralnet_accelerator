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


module control
(
    input clk, rst, start,
    output idle,
    output [15:0] load,
    output logic [8:0] weight_addr_rd,
    output [6:0] activation_addr_rd,
    output [6:0] activation_addr_wr,
    output [15:0] activation_enb_wr,
    output [7:0] alpha_addr_rd 
);

    localparam int layers = 4;
    localparam int degrees [layers] = {784,128,64,10};
    
    logic [4:0] state = 1;
    logic [4:0] next_state;
    logic [1:0] start_reg = 0;
    
    logic [3:0][15:0] load_reg;
    logic [5:0][15:0] activation_enb_wr_reg;
    logic [15:0] next_activation_enb_wr_reg;
    logic [2:0][7:0] alpha_addr_rd_reg; 
    logic [6:0][6:0] activation_addr_wr_reg;
    logic [5:0] activation_addr_rd_reg;
    
    logic [1:0] layer_num, next_layer_num;
    logic [10:0] neuron_num, next_neuron_num;
    logic [10:0] input_num;
    logic [5:0] state8_counter;
    logic [2:0] state16_counter;
    
    always_ff @ (posedge clk) 
    begin
        if(rst)
        begin
            state <= 1;
            start_reg <= 0;
        end
        else 
        begin
            state <= next_state;
            start_reg <= {start_reg[0], start};
        end
    end
    
    always_ff @ (posedge clk)
    begin
        load_reg[3:1] <= load_reg[2:0];
        activation_enb_wr_reg[5:1] <= activation_enb_wr_reg[4:0];
        activation_addr_wr_reg[6:1] <= activation_addr_wr_reg[5:0];
        alpha_addr_rd_reg[2:1] <= alpha_addr_rd_reg[1:0]; 
    end
    
    
    always_ff @ (posedge clk)
    begin
        case (state) inside
            5'b???1?, 5'b????1 : begin
                load_reg[0] <= ~0;
                weight_addr_rd <= 0;
                activation_addr_rd_reg <= 0;
                activation_addr_wr_reg[0] <= 0;
                activation_enb_wr_reg[0] <= 0;
                alpha_addr_rd_reg[0] <= 0;
                
                layer_num <= 0;
                neuron_num <= 0;
                input_num <= 0;
                state8_counter <= 0;
                state16_counter <= 0;
            end
            5'b??1?? : begin
                for(int i = 0; i < 16; i++)
                begin
                    if(i < degrees[layer_num+1] - neuron_num)
                        load_reg[0][i] <= 0;
                    else
                        load_reg[0][i] <= 1;
                end
                
                weight_addr_rd <= weight_addr_rd + 1;
                activation_addr_rd_reg <= activation_addr_rd_reg +1;
                if(neuron_num == 0)
                    activation_addr_wr_reg[0] <= {~layer_num[0], 6'b0};
                else
                    activation_addr_wr_reg[0] <= activation_addr_wr_reg[0];            
                activation_enb_wr_reg[0] <= 0;
                alpha_addr_rd_reg[0] <= alpha_addr_rd_reg[0];
                
                layer_num <= layer_num;
                neuron_num <= neuron_num;
                input_num <= input_num + 16;
                state8_counter <= 0;
                state16_counter <= 0;
            end
            5'b?1??? : begin
                load_reg[0] <= ~0;
                weight_addr_rd <= weight_addr_rd;
                activation_addr_rd_reg <= 0;
                
                if(state8_counter == 15)
                    activation_addr_wr_reg[0] <= activation_addr_wr_reg[0] + 1;
                else
                    activation_addr_wr_reg[0] <= activation_addr_wr_reg[0];                
                activation_enb_wr_reg[0] <= next_activation_enb_wr_reg;
                alpha_addr_rd_reg[0] <= alpha_addr_rd_reg[0] + 1;
                
                layer_num <= next_layer_num;
                neuron_num <= next_neuron_num;
                input_num <= 0;
                state8_counter <= state8_counter + 1;
                state16_counter <= 0;
            end
            5'b1???? : begin
                load_reg[0] <= ~0;
                weight_addr_rd <= 0;
                activation_addr_rd_reg <= 0;
                activation_addr_wr_reg[0] <= 0;
                activation_enb_wr_reg[0] <= 0;
                alpha_addr_rd_reg[0] <= 0;
                
                layer_num <= 0;
                neuron_num <= 0;
                input_num <= 0;
                state8_counter <= 0;
                state16_counter <=state16_counter+1;
            end
        endcase
    end
    
    always_comb
    begin
        next_state = state;
        next_activation_enb_wr_reg = 0;
        next_activation_enb_wr_reg[state8_counter[3:0]] = 1;
        
        next_layer_num = layer_num;
        next_neuron_num = neuron_num;
            
        case (state) inside
            5'b????1: begin
                if(start_reg == 2'b01)
                    next_state = 2;
                else
                    next_state = 1;
            end
            5'b???1?: begin
                if(start_reg == 2'b10)
                    next_state = 4;
                else
                    next_state = 2;
            end
            5'b??1??: begin
                if(degrees[layer_num] - input_num <= 16)
                    next_state = 8;    
                else 
                    next_state = 4; 
            end
            5'b?1???: begin
                if(degrees[layer_num+1] - neuron_num <= 16) 
                begin
                    //this is the last neuron group to process
                    if(state8_counter == degrees[layer_num+1] - neuron_num -1)
                    begin
                        if(layer_num == layers - 2)
                            next_state = 16;
                        else begin
                            next_state = 4;   
                            next_layer_num = layer_num + 1;
                            next_neuron_num = 0;
                        end                     
                    end
                    else 
                        next_state = 8; 
                end
                else 
                begin
                    //more neuron groups to process
                    if(state8_counter == 15) begin 
                        next_state = 4;
                        next_neuron_num = neuron_num + 16;
                    end
                    else
                        next_state = 8;                    
                end    
            end
            5'b1????: begin
                if(state16_counter == 5)
                    next_state = 1;
                else
                    next_state = 16;
            end
        endcase
    end
    
    
    assign idle = state[0];
    assign load = load_reg[3];
    assign activation_enb_wr = activation_enb_wr_reg[5];
    assign activation_addr_wr = activation_addr_wr_reg[6];
    assign activation_addr_rd = {layer_num[0], activation_addr_rd_reg};
    assign alpha_addr_rd = alpha_addr_rd_reg[2];
    
endmodule