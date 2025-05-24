`include "define.v"

module Execute(
    input [31:0] pc,          // 程序计数器
    input [31:0] rs1_data,    // 寄存器1数据
    input [31:0] rs2_data,    // 寄存器2数据
    input [31:0] imm,         // 立即数
    input [6:0] funct7,       // 功能码7
    input [2:0] funct3,       // 功能码3
    input [3:0] alu_op,       // ALU操作码
    input [1:0] alu_src,      // ALU输入源选择
    output [31:0] alu_result, // ALU计算结果
    output zero               // 零标志位
);

// 内部连线
wire [3:0] alu_control;

// 实例化ALU控制单元
ALU_Control alu_control_inst(
    .ALU_Op(alu_op),
    .fun7(funct7),
    .fun3(funct3),
    .ALU_Control(alu_control)
);

// 实例化ALU
ALU alu_inst(
    .pc(pc),
    .ALU_Control(alu_control),
    .ALU_Src(alu_src),
    .ReadData1(rs1_data),
    .ReadData2(rs2_data),
    .fun3(funct3)
    .imm32(imm),
    .ALU_Result(alu_result),
    .zero(zero)
);

endmodule