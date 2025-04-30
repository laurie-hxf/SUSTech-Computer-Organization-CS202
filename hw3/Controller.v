module Controller (
    input [31:0] inst,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg[1:0] ALUOp
);
    // wire [6:0] opcode = instruction[6:0];
    wire [6:0] opcode;
    assign opcode = inst[6:0];
    always @(*) begin
        Branch = 1'b0;
        MemRead= 1'b0;
        MemtoReg= 1'b0;
        MemWrite= 1'b0;
        ALUSrc= 1'b0;
        RegWrite= 1'b0;
        ALUOp= 2'b11;
        case (opcode)
            7'b0110011: begin // R-type
               RegWrite= 1'b1;
               ALUOp= 2'b10;
            end
            7'b0010011: begin // I-type
                ALUSrc= 1'b1;
                RegWrite= 1'b1;
            end
            7'b0000011: begin // I-type
                MemRead= 1'b1;
                MemtoReg= 1'b1;
                ALUSrc= 1'b1;
                RegWrite= 1'b1;
                ALUOp= 2'b00;
            end
            7'b0100011: begin // S-type
                MemWrite= 1'b1;
                ALUSrc= 1'b1;
                ALUOp= 2'b00;
            end
            7'b1100011: begin // B-type
                Branch = 1'b1;
                ALUOp= 2'b01;
            end
            // 7'b0110111: begin // U-type
                
            // end
            // 7'b1101111: begin // J-type
               
            // end
            default: begin
               
            end
        endcase
    end
endmodule


