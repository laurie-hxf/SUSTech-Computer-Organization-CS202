`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/23 14:59:14
// Design Name: 
// Module Name: mem_switch
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

module mem_switch(
    input [1:0] a7,
    input mem_read,
    input mem_write,
    input [13:0] alu_result_addr,
    output reg [2:0] led_control,
    output reg [2:0] switch_control
    );

    always @(*) begin
        if (a7 == 2'b10) begin
            switch_control = 3'b110;
        end
        else if (mem_read && alu_result_addr[13:3] == `SWITCH_MEM) begin
            switch_control = alu_result_addr[2:0];
        end
        else begin
            switch_control = 3'b000;
        end
    end
    
    always @(*) begin
        if (a7 == 2'b11) begin
            led_control = 3'b100;
        end
        else if (mem_write && alu_result_addr[13:3] == `LED_MEM) begin
            led_control = alu_result_addr[2:0];
        end
        else begin
            led_control = 3'b000;
        end
    end
    
endmodule
