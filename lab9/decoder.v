module RegisterFile (
    input clk,
    input we,  // write enable
    input [4:0] rs1,  // read reg 1
    input [4:0] rs2,  // read reg 2
    input [4:0] rd,   // write reg
    input [31:0] wd,  // write data
    output [31:0] rd1,  // read data 1
    output [31:0] rd2   // read data 2
);

    reg [31:0] regs [31:0];  // 32个寄存器，每个32位

    // 写寄存器，只在上升沿写入
    always @(posedge clk) begin
        if (we && rd != 5'b00000) begin
            regs[rd] <= wd;
        end
    end

    // 异步读
    assign rd1 = (rs1 == 5'b00000) ? 32'b0 : regs[rs1];
    assign rd2 = (rs2 == 5'b00000) ? 32'b0 : regs[rs2];

endmodule


module tb_RegisterFile;

    reg clk;
    reg we;
    reg [4:0] rs1, rs2, rd;
    reg [31:0] wd;
    wire [31:0] rd1, rd2;

    RegisterFile uut (
        .clk(clk), .we(we),
        .rs1(rs1), .rs2(rs2), .rd(rd),
        .wd(wd),
        .rd1(rd1), .rd2(rd2)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns 时钟周期
    end

    // 测试用例
    initial begin
        $dumpfile("decoder.vcd");  // 指定输出的波形文件名
        $dumpvars;
        $display("Start Test");
        we = 0; wd = 0; rd = 0; rs1 = 0; rs2 = 0;

        // 尝试写入 x1 = 32'hDEADBEEF
        #10;
        we = 1; rd = 5'd1; wd = 32'hDEADBEEF;
        #10;
        we = 0;

        // 读取 x1 到 rd1，x0 到 rd2
        rs1 = 5'd1; rs2 = 5'd0;
        #10;
        $display("x1 = %h (expect DEADBEEF), x0 = %h (expect 0)", rd1, rd2);

        // 尝试写入 x0
        we = 1; rd = 5'd0; wd = 32'hFFFFFFFF;
        #10;
        we = 0;

        // 再次读取 x0
        rs1 = 5'd0;
        #10;
        $display("x0 = %h (expect 0)", rd1);

        #100 $finish;

    end

endmodule
