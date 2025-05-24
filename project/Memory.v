`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/29 22:02:51
// Design Name: 
// Module Name: Stage_Mem
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

`include "define.v"
module stage_mem (
    input         clk,              
    input         rst,               
    input         clk_p,             
    input         stop,              
    input         mem_read,          
    input         mem_write,         
    input  [31:0] alu_result_addr,   
    input  [31:0] mem_write_data,   
    input  [1:0]  a7,               
    output [31:0] mem_read_data,     
    output [2:0]  switch_control,    
    output [2:0]  led_control  
);
    wire clk_inverted = ~clk;        
   
    reg [13:0] mem_ptr;              
    wire [13:0] zero_addr = 14'b0;   
    
    always @(negedge clk_p) begin
        if (stop) begin
            mem_ptr <= mem_ptr + 1;  
        end else begin
            mem_ptr <= `OUT_START - 1;
        end
    end

    wire [13:0] mem_access_addr = stop ? mem_ptr : 
                                 (a7[1] ? zero_addr : alu_result_addr[15:2]);
    RAM mem (
        .clka(clk_inverted),
        .wea(mem_write),
        .addra(mem_access_addr),
        .dina(mem_write_data),
        .douta(mem_read_data)
    );
    mem_switch  (
        .a7(a7),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .alu_result_addr (alu_result_addr[15:2]),
        .led_control(led_control),
        .switch_control(switch_control)
    );

endmodule
