module ALU(
    input  [1:0]  ALUOp,
    input   ALUSrc,
    input  [31:0] ReadData1,
    input  [31:0] ReadData2,
    input  [31:0] imm32,
    input [6:0] funct7,
    input [2:0] funct3,
    output reg [31:0] ALUResult,
    output zero  
);
reg [3:0] ALUControl;
wire[31:0] operand2;
assign operand2 = (ALUSrc == 1'b0) ? ReadData2 :
                  (ALUSrc == 1'b1) ? imm32 :
                  32'b0;

always @* begin
    case(ALUOp)
    2'b00,2'b01: ALUControl = { ALUOp, 2'b10};
    2'b10:
        case({funct7,funct3})
            10'b0000000_000: ALUControl = 4'b0010;
            10'b0100000_000: ALUControl = 4'b0110;
            10'b0000000_111: ALUControl = 4'b0000;
            10'b0000000_110: ALUControl = 4'b0001;
        endcase
    endcase

    case (ALUControl)
        4'b0010: ALUResult = ReadData1 + operand2;    // ADD
        4'b0110: ALUResult = ReadData1 - operand2;    // SUB
        4'b0000: ALUResult = ReadData1 & operand2;    // AND
        4'b0001: ALUResult = ReadData1 | operand2;    // OR
        default: ALUResult = 32'b0;
    endcase
end

assign zero = (ALUResult == 32'b0);  // assign 可以用 wire 类型
endmodule