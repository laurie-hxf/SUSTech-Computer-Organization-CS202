module PC(
    input clk,
    input rst,
    input [31:0] imm,
    input zero,
    input branch,
    input [31:0] rs1,
    input jal,
    input jalr,
    output reg [31:0] pc
);

reg [31:0] next_pc;
reg [31:0] pc_reg;  // 新增一个内部寄存器

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


always @(*) begin
    pc = pc_reg;
end

endmodule
