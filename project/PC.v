module PC(
    input clk,
    input rst,
    input [31:0] imm,
    input zero,
    input branch,
    input [31:0] rs1,
    input jal,
    input jalr,
    output reg [31:0] inst
    // output [31:0]pc,
    // output [31:0]n_pc
);


reg [31:0] next_pc;
reg [31:0] pc_reg;  // 新增一个内部寄存器
wire [13:0] rom_addr;
assign rom_addr = pc_reg[15:2];

    prgrom urom (
        .clka(clk),
        .addra(rom_addr),
        .douta(inst)
    );

always @(*) begin
    if (jal)
        next_pc = pc_reg + {imm,1'b0};
    else if(jalr)
        next_pc = rs1 + imm;
    else
        next_pc = ((zero & branch) == 0) ? (pc_reg + 32'd4) : (pc_reg + {imm,1'b0});
end

always @(posedge clk) begin
    if (rst)
        pc_reg <= 0;
    else
        pc_reg <= next_pc;
end

// assign n_pc = next_pc;

endmodule



`timescale 1ns / 1ps

module tb_PC;

    // Inputs
    reg clk_tb;
    reg rst_tb;
    reg [31:0] imm_tb;
    reg zero_tb;
    reg branch_tb;
    reg [31:0] rs1_tb;
    reg jal_tb;
    reg jalr_tb;

    // Outputs
    wire [31:0] pc_out;
    wire [31:0] n_pc;

    // Instantiate the Unit Under Test (UUT)
    PC uut (
        .clk(clk_tb),
        .rst(rst_tb),
        .imm(imm_tb),
        .zero(zero_tb),
        .branch(branch_tb),
        .rs1(rs1_tb),
        .jal(jal_tb),
        .jalr(jalr_tb),
        .pc(pc_out),
        .n_pc(n_pc)
    );

    // Clock generation
    initial begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb; 
    end

    // Test sequence
    initial begin
        $dumpfile("PC.vcd");  
        $dumpvars;
        $display("时间\t rst\t imm\t\t zero\t branch\t rs1\t\t jal\t jalr\t | pc_out (next_pc)");
        $monitor("%dns\t %b\t %h\t %b\t %b\t %h\t %b\t %b\t | %h (内部 pc_reg: %h)",
                 $time, rst_tb, imm_tb, zero_tb, branch_tb, rs1_tb, jal_tb, jalr_tb, pc_out, uut.pc_reg);


        rst_tb = 0;
        imm_tb = 32'h0;
        zero_tb = 0;
        branch_tb = 0;
        rs1_tb = 32'h0;
        jal_tb = 0;
        jalr_tb = 0;
        #10; 


        $display("--- 1. 复位测试 ---");
        rst_tb = 1;
        #10; 
        rst_tb = 0;
        #10;
        $display("--- 3. 条件分支 (Branch Taken) ---");
       
        imm_tb = 32'h0000_000A; 
        zero_tb = 1;
        branch_tb = 1;
        jal_tb = 0;
        jalr_tb = 0;
    
        #10; 
        $display("--- 4. 条件分支 (Branch Not Taken) ---");

        imm_tb = 32'h0000_000F; 
        zero_tb = 0;
        branch_tb = 1;
        jal_tb = 0;
        jalr_tb = 0;
        #10; 
        $display("--- 10. JAL 跳转 ---");
        
        imm_tb = 32'h0000_0100; 
        zero_tb = 0; // 无关
        branch_tb = 0; // 无关 
        jal_tb = 1;
        jalr_tb = 0;

        #10;
        $display("--- 6. JALR 跳转 ---");
    
        rs1_tb = 32'h1000_0000;
        imm_tb = 32'h0000_0080; 
        zero_tb = 0; 
        branch_tb = 0; 
        jal_tb = 0;
        jalr_tb = 1;
        
        #10; 
        $display("--- 7. JALR 后顺序执行 ---");
        
        imm_tb = 32'h0; zero_tb = 0; branch_tb = 0; jal_tb = 0; jalr_tb = 0; rs1_tb = 32'h0;
        #10; 

        $display("--- 测试结束 ---");
        #20 $finish;
    end

endmodule
