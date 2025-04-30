module IFetch (
    input clk,
    input rst,
    input [31:0] imm32,
    input branch,
    input zero,
    output [31:0] inst
);

    reg [31:0] pc;

    wire [13:0] rom_addr;
    assign rom_addr = pc[15:2];  // byte address >> 2, because 32-bit aligned (4-byte per instruction)

    // Instruction ROM
    prgrom urom (
        .clka(clk),
        .addra(rom_addr),
        .douta(inst)
    );

    // PC update on negedge
    always @(negedge clk) begin
        if (!rst)
            pc <= 32'h00000000;  // synchronous reset, active low
        else if (branch && zero)
            pc <= pc + imm32;    // jump taken
        else
            pc <= pc + 32'd4;    // next instruction
    end

endmodule
