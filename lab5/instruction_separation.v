module instruction_decoder (
    input [31:0] instruction,
    output reg [31:0] immediate,
    output  [6:0] opcode
);
    // wire [6:0] opcode = instruction[6:0];
    assign opcode = instruction[6:0];
    
    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-type
                immediate = 32'h00000000; // R-type has no immediate, set to 0
            end
            7'b0010011: begin // I-type
                immediate = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0000011: begin // I-type
                immediate = {{20{instruction[31]}}, instruction[31:20]};
            end
            7'b0001111: begin // S-type
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            end
            7'b0100011: begin // B-type
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            end
            7'b0110111: begin // U-type
                immediate = {instruction[31:12], 12'b0};
            end
            7'b1101111: begin // J-type
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            end
            default: begin
                immediate = 32'h00000000; // Default case
            end
        endcase
    end
endmodule


`timescale 1ns / 1ps

module instruction_decoder_tb;
    reg [31:0] instruction;
    wire [31:0] immediate;
    
    instruction_decoder uut (
        .instruction(instruction),
        .immediate(immediate)
    );
    
    initial begin
        $dumpfile("lab7.vcd");  // 指定输出的波形文件名
        $dumpvars;
        $monitor("Time=%0t | Instruction=%b | Immediate=%h", $time, instruction, immediate);
        
        // R-type (should output 0)
        instruction = 32'b00000000000000000000_00000_0110011; #1;
        
        // I-type (example: ADDI)
        instruction = 32'b111111111111_00000_000_00001_0010011; #1; // Immediate =  (0xFFFFFFFF)
        
        // S-type (example: SW)
        instruction = 32'b1111111_00000_00000_001_00001_0001111; #1; // Immediate =  (0xFFFFFFE1)
        
        // B-type (example: BEQ)
        instruction = 32'b1_111110_00000_00000_000_0000_1_0100011; #1; // Immediate = -32 (0xFFFFFFC0)
                                    //1111_1111_1100_0000     
        // U-type (example: LUI)
        instruction = 32'b00000000000000000001_00000_0110111; #1; // Immediate = 0x00001000
        
        // J-type (example: JAL)
        instruction = 32'b0_0000000000_0_00000001_00000_1101111; #1; // Immediate = 0x00001000
                        //0000_0001_0000_0000_0000
        $finish;
    end
endmodule