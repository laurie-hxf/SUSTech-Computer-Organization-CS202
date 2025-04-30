module Decoder (
    input clk,
    input rst,
    input regWrite,  // write enable
    input [31:0] inst,
    input [31:0] writeData,  // write data
    output [31:0] rs1Data,  // read data 1
    output [31:0] rs2Data,   // read data 2
    output reg [31:0] imm32
);

    reg [31:0] regs [31:0];  // 32个寄存器，每个32位

    wire [4:0] rs1 = inst[19:15];
    wire [4:0] rs2 = inst[24:20];
    wire [4:0] rd  = inst[11:7];
    wire [6:0] opcode = inst[6:0];
    wire [2:0] funct3 = inst[14:12];

    // 异步读
    assign rs1Data = (rs1 == 5'b00000) ? 32'b0 : regs[rs1];
    assign rs2Data = (rs2 == 5'b00000) ? 32'b0 : regs[rs2];

    
    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-type
                imm32 = 32'h00000000; // R-type has no imm32, set to 0
            end
            7'b0010011: begin // I-type
                imm32 = {{20{inst[31]}}, inst[31:20]};
            end
            7'b0000011: begin // I-type
                imm32 = {{20{inst[31]}}, inst[31:20]};
            end
            7'b0100011: begin // S-type
                imm32 = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            end
            7'b1100011: begin // B-type
                imm32 = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            end
            default: begin
                imm32 = 32'h00000000; // Default case
            end
        endcase
    end

    // 写寄存器，只在上升沿写入
    integer i;
    always @(posedge clk) begin
        if (!rst) begin
            // reset all registers to 0 when rst = 0
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (regWrite && rd != 5'b00000) begin
            // write to register file if regWrite is 1 and rd != x0
            regs[rd] <= writeData;
        end
    end



endmodule