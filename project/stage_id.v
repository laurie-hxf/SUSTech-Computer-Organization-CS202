`timescale 1ns / 1ps

`define SP_INIT 32'h0000_1000;

module stage_id (
    input clk,
    input rst,
    input [31:0] Inst,
    input [31:0] sw_data,

    output reg Branch,
    output reg Memread,
    output reg Memtoreg,
    output reg [3:0] ALUop,
    output reg Memwrite,
    output reg ALUSRC,
    output reg RegWrite,
    output [31:0] Reg_out1,
    output [31:0] Reg_out2,
    output reg [31:0] Imm,
    output reg [6:0] func7,
    output reg [2:0] func3
);

    reg [31:0] Reg[31:0];
    reg [31:0] w_data;

    always @(*) begin
        Branch = 1'b0;
        Memread = 1'b0;
        Memtoreg = 1'b0;
        ALUop = 4'b0;
        Memwrite = 1'b0;
        ALUSRC = 1'b0;
        RegWrite = 1'b0;
        func3 = 3'b0;
        func7 = 7'b0;
        Imm = 32'b0;
        if (!rst) begin
            case (Inst[6:0])
                7'b0110011: begin// R
                    func3 = Instruction[14:12];
                    func7 = Instruction[31:25];
                    ALUSRC = 1'b0;
                    RegWrite = 1'b1;
                    ALUop = 4'b0000;
                end
                7'b0010011: begin  // I
                    func3 = Instruction[14:12];
                    Imm = {{20{Instruction[31]}}, Instruction[31:20]};
                    ALUSRC = 1'b1;
                    RegWrite = 1'b1;
                    ALUop = 4'b0001;
                end
                7'b0000011: begin  //I
                    func3 = Instruction[14:12];
                    Imm = {{20{Instruction[31]}}, Instruction[31:20]};
                    ALUSRC = 1'b1;
                    Memtoreg = 1'b1;
                    RegWrite = 1'b1;
                    Memread = 1'b1;
                    ALUop = 4'b0010;
                end
                7'b0100011: begin //S
                    func3 = Instruction[14:12];
                    Imm = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};
                    ALUSRC = 1'b1;
                    Memwrite = 1'b1;
                    ALUop = 4'b0011;
                end
                7'b1100011: begin //B
                    func3 = Instruction[14:12];
                    Imm = {{20{Instruction[31]}},Instruction[7],Instruction[30:25],Instruction[11:8],1'b0};
                    Branch = 1'b1;
                    ALUop = 4'b0100;
                end
                7'b1101111: begin // J
                    Imm = {{12{Instruction[31]}},Instruction[19:12],Instruction[20],Instruction[30:21],1'b0};
                    ALUSRC = 1'b1;
                    RegWrite = 1'b1;
                    ALUop = 4'b0101;
                end
                7'b0110111: begin //U
                    Imm = {Instruction[31:12], 12'b0};
                    ALUSRC = 1'b1;
                    RegWrite = 1'b1;
                    ALUop = 4'b0111; // ALU_OP_LUI
                end
                7'b0010111: begin
                    Imm = {Instruction[31:12], 12'b0};
                    ALUSRC = 1'b1;
                    RegWrite = 1'b1;
                    ALUop = 4'b1000; // ALU_OP_AUIPC
                end
            endcase
        end
    end

    assign Reg_out1 = Reg[Inst[19:15]];
    assign Reg_out2 = Reg[Inst[24:20]];

    always @(negedge clk) begin
        if (rst) begin
            for (integer i = 0; i < 32; i = i + 1) begin
                if (i == 2) Reg[i] <= `SP_INIT;
                else Reg[i] <= 0;
            end
        end else if (RegWrite && Inst[11:7] != 5'b0) begin
            Reg[Inst[11:7]] <= sw_data;
        end
    end

endmodule
