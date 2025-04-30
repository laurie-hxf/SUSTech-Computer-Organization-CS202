module ALU_Control(
    input [1:0] ALUOp,
    input [6:0] fun7,
    input [2:0] fun3,
    output [3:0] ALUControl

);

always @ * begin
    case(ALUOp)
    2'b00,2'b01: ALUControl = { ALUOp, 2'b10};
    2'b10:
        case({fun7,fun3})
            10'b0000000_000: ALUControl = 4'b0010;
            10'b0100000_000: ALUControl = 4'b0110;
            10'b0000000_111: ALUControl = 4'b0000;
            10'b0000000_110: ALUControl = 4'b0001;
        endcase
    endcase
end
endmodule