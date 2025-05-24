`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/23 00:14:05
// Design Name: 
// Module Name: IFench
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

module stage_if (
    input clk,
    input rst,
    input branch,
    input zero,
    input Jump,
    input [31:0]rs1,
    input JR,
    input [31:0] imm,
    output [31:0] instruct,
    output reg [31:0] pc,
    output reg Stop
);
    reg [2:0]cnt=0;
    wire trans_clk;
    assign trans_clk = clk;
    reg [31:0] next_pc;
    
    program urom (
        .clka(trans_clk),  
        .addra(pc[15:2]), 
        .douta(instruct)
    );

    always @(*) begin
        if (JR) begin
            next_pc = rs1 + imm;
        end 
        else if ((branch && zero) || Jump) begin
            next_pc = pc + imm;
        end else begin
            next_pc = pc + 4;
        end
    end
    always @(negedge clk) begin
        if (rst) begin
            pc <= 0;
            cnt<= 0;
            Stop<=0; 
        end else begin
            if(instruct==0)begin
                cnt<= (cnt==3'b111) ? cnt : (cnt+1);
            end else begin
                cnt<=0;
            end
            if(cnt==3'b111)begin
                Stop<=1'b1;
            end else begin
                Stop<=1'b0;
            end
            if(Stop == 0)begin
                pc <= next_pc;
            end else begin
                pc <= pc;
            end
        end
    end
endmodule