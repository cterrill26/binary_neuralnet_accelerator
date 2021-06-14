`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2021 11:04:30 PM
// Design Name: 
// Module Name: ram_dp
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


module ram_dp
#(
    parameter RAM_WIDTH = 8,              
    parameter RAM_DEPTH = 1024,              
    parameter INIT_FILE = ""
)
(
    input clk,                       
    input [$clog2(RAM_DEPTH)-1:0] addr_wr, 
    input [$clog2(RAM_DEPTH)-1:0] addr_rd, 
    input [RAM_WIDTH-1:0] data_in,         
    input [RAM_WIDTH-1:0] enb_wr,                         
    output [RAM_WIDTH-1:0] data_out             
);   
    



   
    logic [RAM_WIDTH-1:0] mem [RAM_DEPTH-1:0];
    logic [RAM_WIDTH-1:0] mem_data;
    logic [RAM_WIDTH-1:0] mem_reg;
    
    generate
        if (INIT_FILE != "") begin: use_init_file
          initial
            $readmemh(INIT_FILE, mem, 0, RAM_DEPTH-1);
        end 
    endgenerate
    
    
    generate
        for(genvar i = 0; i < RAM_WIDTH; i++) begin : bit_select
            always_ff @(posedge clk) 
            begin
                if (enb_wr[i])
                  mem[addr_wr][i] <= data_in[i];
            end
        end
    endgenerate
    
    always_ff @(posedge clk) 
    begin
        mem_data <= mem[addr_rd];
        mem_reg <= mem_data;
    end

    assign data_out = mem_reg;
					
endmodule
