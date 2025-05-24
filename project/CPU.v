module CPU(
    input clk,
    input rst,
    input [15:0] switch,
    output [15:0] led,
    output [3:0] R,
    output [3:0] G,
    output [3:0] B,
    output hs,
    output vs,
    output [7:0] seg_out,
    output [7:0] tub_sel

);
wire [31:0]imm,rs1,inst;
wire [31:0] rs2;
wire [31:0] pc;
wire [31:0] alu_result;
wire [6:0] funct7;
wire [2:0] funct3;
wire [3:0] alu_op;
wire [1:0] alu_src;
wire zero,branch,jal,jalr;

// 新增ID阶段的信号
wire memread, memtoreg, memwrite, alusrc, regwrite;


// 新增MEM阶段的信号
wire [31:0] mem_read_data;
wire [2:0] switch_control;
wire [2:0] led_control;
wire clk_p;  // 时钟信号，需要从外部获取或生成
wire stop;   // 停止信号，需要从控制单元获取
wire [1:0] a7;  // 需要从指令中提取或从其他模块获取
wire [31:0] sw_data;
assign sw_data = {16'b0, switch};

PC pc_inst(
    .clk(clk),
    .rst(rst),
    .imm(imm),
    .zero(zero),
    .branch(branch),
    .rs1(rs1),
    .jal(jal),
    .jalr(jalr),
    .inst(inst)
);

// 添加ID阶段模块
stage_id id(
    .clk(clk),
    .rst(rst),
    .Inst(inst),
    .sw_data(sw_data),
    .Branch(branch),
    .Memread(memread),
    .Memtoreg(memtoreg),
    .ALUop(alu_op),
    .Memwrite(memwrite),
    .ALUSRC(alusrc),
    .RegWrite(regwrite),
    .Reg_out1(rs1),
    .Reg_out2(rs2),
    .Imm(imm),
    .func7(funct7),
    .func3(funct3)
);

Execute ex(
    .pc(pc),                  // 程序计数器
    .rs1_data(rs1),          // 第一个寄存器数据
    .rs2_data(rs2),          // 第二个寄存器数据
    .imm(imm),               // 立即数
    .funct7(funct7),         // 功能码7
    .funct3(funct3),         // 功能码3
    .alu_op(alu_op),         // ALU操作码
    .alu_src(alu_src),       // ALU源选择
    .alu_result(alu_result), // ALU结果
    .zero(zero)              // 零标志位
);

// 新增MEM阶段模块
stage_mem mem(
    .clk(clk),
    .rst(rst),
    .clk_p(clk_p),        // 需要确认时钟信号来源
    .stop(stop),          // 需要确认停止信号来源
    .mem_read(memread),
    .mem_write(memwrite),
    .alu_result_addr(alu_result),
    .mem_write_data(rs2), // 使用rs2作为写入数据
    .a7(a7),              // 需要确认a7信号来源
    .mem_read_data(mem_read_data),
    .switch_control(switch_control),
    .led_control(led_control)
);







endmodule