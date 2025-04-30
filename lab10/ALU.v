module ALU(
    input  [3:0]  ALUControl,
    input  [1:0]  ALUSrc,
    input  [31:0] ReadData1,
    input  [31:0] ReadData2,
    input  [31:0] imm32,
    output reg [31:0] ALUResult,
    output wire zero  // 修改为a wire，并改成 1 位
);

wire[31:0] operand2;
assign operand2 = (ALUSrc == 2'b00) ? ReadData2 :
                  (ALUSrc == 2'b01) ? imm32 :
                  32'b0;

always @* begin
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



module ALU_tb;
    reg [3:0]  ALUControl;
    reg [1:0]  ALUSrc;
    reg [31:0] ReadData1, ReadData2, imm32;
    wire [31:0] ALUResult;
    wire zero;

    ALU uut (
        .ALUControl(ALUControl),
        .ALUSrc(ALUSrc),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .imm32(imm32),
        .ALUResult(ALUResult),
        .zero(zero)
    );

    initial begin
        $dumpfile("ALU.vcd");  // 指定输出的波形文件名
        $dumpvars;
        // 初始化
        ReadData1 = 32'd10;
        ReadData2 = 32'd5;
        imm32     = 32'd3;

        // 测试 ADD: ReadData1 + ReadData2
        ALUControl = 4'b0010;
        ALUSrc     = 2'b00;
        #10;
        $display("ADD: %d", ALUResult);

        // 测试 SUB: ReadData1 - ReadData2
        ALUControl = 4'b0110;
        ALUSrc     = 2'b00;
        #10;
        $display("SUB: %d", ALUResult);

        // 测试 AND: ReadData1 & ReadData2
        ALUControl = 4'b0000;
        ALUSrc     = 2'b00;
        #10;
        $display("AND: %d", ALUResult);

        // 测试 OR: ReadData1 | ReadData2
        ALUControl = 4'b0001;
        ALUSrc     = 2'b00;
        #10;
        $display("OR: %d", ALUResult);

        // 测试立即数：ReadData1 + imm32
        ALUControl = 4'b0010;
        ALUSrc     = 2'b01;
        #10;
        $display("ADD with imm: %d", ALUResult);

        // 测试 zero flag
        ReadData1 = 32'd10;
        ReadData2 = 32'd10;
        ALUControl = 4'b0110; // SUB
        ALUSrc     = 2'b00;
        #10;
        $display("Zero flag: %b", zero);

        $finish;
    end
endmodule
