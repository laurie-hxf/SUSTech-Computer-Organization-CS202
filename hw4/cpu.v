module CPUv1 (
    input clk_top,    // 时钟信号
    input rst_top     // 异步低有效复位
);

    wire [31:0] inst;
    wire [31:0] rs1Data, rs2Data, imm32;
    wire [31:0] alu_result, dout;
    wire [31:0] writeData;

    wire [1:0] ALUOp;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire zero;

    wire Branch, MemRead, MemWrite, MemtoReg, ALUSrc, RegWrite;

    IFetch uIF (
        .clk(clk_top),
        .rst(rst_top),
        .branch(Branch),
        .zero(zero),
        .imm32(imm32),
        .inst(inst)
    );

    Controller uCtrl (
        .inst(inst),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp)
    );

    Decoder uDecd (
        .clk(clk_top),
        .rst(rst_top),
        .regWrite(RegWrite),
        .inst(inst),
        .writeData(writeData),
        .rs1Data(rs1Data),
        .rs2Data(rs2Data),
        .imm32(imm32)
    );

    assign funct3 = inst[14:12];
    assign funct7 = inst[31:25];

    ALU uALU (
        .rs1D(rs1Data),
        .rs2D(rs2Data),
        .imm32(imm32),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .ALUSrc(ALUSrc),
        .alu_result(alu_result),
        .zero(zero)
    );

    DMem uDMem (
        .clk(clk_top),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .din(rs2Data),
        .dout(dout)
    );

    assign writeData = MemtoReg ? dout : alu_result;

endmodule
