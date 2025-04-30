`include "define.v"
module ALU(
    input [31:0]  pc,
    input  [3:0]  ALU_Control,
    input  [1:0]  ALU_Src,
    input  [31:0] ReadData1,
    input  [31:0] ReadData2,
    input  [31:0] imm32,
    output reg [31:0] ALU_Result,
    output reg zero  
);
wire [3:0] ALU_Op;
wire [6:0] fun7;
wire [2:0] fun3;
    ALU_Control control (
        .ALU_Op(ALU_Op),
        .fun7(fun7),
        .fun3(fun3),
        .ALU_Control(ALU_Control)
    );

wire[31:0] operand2;
assign operand2 = (ALU_Src == 2'b00) ? ReadData2 :
                  (ALU_Src == 2'b01) ? imm32 :
                  32'b0;

always @* begin
    case (ALU_Control)
        `ALU_Control_ADD: ALU_Result = ReadData1 + operand2;    // ADD
        `ALU_Control_SUB: ALU_Result = ReadData1 - operand2;    // SUB
        `ALU_Control_AND: ALU_Result = ReadData1 & operand2;    // AND
        `ALU_Control_OR: ALU_Result = ReadData1 | operand2;    // OR
        `ALU_Control_XOR: ALU_Result = ReadData1 ^ operand2;    // XOR
        `ALU_Control_Shift_Left: ALU_Result = ReadData1 << operand2;   // shift left
        `ALU_Control_Shift_Right_U: ALU_Result = ReadData1 >> operand2;   // shift right
        `ALU_Control_Shift_Right: ALU_Result = $signed(ReadData1) >>> operand2; // 算术右移
        `ALU_Control_Set_Less_U: ALU_Result = ReadData1 < operand2 ? 1:0;      // Set Less Than (U) 
        `ALU_Control_Set_Less: ALU_Result = $signed(ReadData1) < $signed(operand2) ? 1:0; //Set Less Than 
        `ALU_Control_Lui: ALU_Result = operand2<<12; //Set Less Than 
        `ALU_Control_Auipc: ALU_Result = pc+(operand2<<12); //Set Less Than 
        `ALU_Control_J: ALU_Result = pc+4; //Set Less Than 
        default: ALU_Result = 32'b0;
    endcase
    if(ALU_Control==`ALU_OP_B)begin
            case (func3)
                3'b000: zero= (ALU_Result==32'b0)?1'b1:1'b0;
                3'b001: zero= (ALU_Result!=32'b0)?1'b1:1'b0;
                3'b100: zero= ($signed(ReadData1) < $signed(operand2))?1'b1:1'b0;
                3'b101: zero= ($signed(ReadData1) >= $signed(operand2))?1'b1:1'b0;
                3'b110: zero= (ReadData1<operand2)?1'b1:1'b0;
                3'b111: zero= (ReadData1>=operand2)?1'b1:1'b0;
            endcase
    end 
    else begin
            zero=1'b0;
    end

end


endmodule


// `include "define.v"

// module ALU_Control(
//     input [3:0] ALU_Op,
//     input [6:0] fun7,
//     input [2:0] fun3,
//     output reg [3:0] ALU_Control
// );

// always @ * begin
//     case(ALU_Op)
//     `ALU_OP_LW,`ALU_OP_SW: ALU_Control = `ALU_Control_ADD;
//     `ALU_OP_B: ALU_Control = `ALU_Control_SUB;
//     `ALU_OP_LUI: ALU_Control = `ALU_Control_Lui;
//     `ALU_OP_AUIPC: ALU_Control = `ALU_Control_Auipc;
//     `ALU_OP_J: ALU_Control = `ALU_Control_J;
//     `ALU_OP_R:
//         case({fun7,fun3})
//             10'b0000000_000: ALU_Control = `ALU_Control_ADD; //add
//             10'b0100000_000: ALU_Control = `ALU_Control_SUB; //sub
//             10'b0000000_111: ALU_Control = `ALU_Control_AND; //and
//             10'b0000000_110: ALU_Control = `ALU_Control_OR; //or
//             10'b0000000_100: ALU_Control = `ALU_Control_XOR; //xor
//             10'b0000000_001: ALU_Control = `ALU_Control_Shift_Left; //shift left
//             10'b0000000_101: ALU_Control = `ALU_Control_Shift_Right_U; //shift right_U
//             10'b0100000_101: ALU_Control = `ALU_Control_Shift_Right; //shift right
//             10'b0000000_011: ALU_Control = `ALU_Control_Set_Less_U; //set less than_U
//             10'b0000000_010: ALU_Control = `ALU_Control_Set_Less; //set less than 
//         endcase
//     `ALU_OP_I:
//         case(fun3)
//             3'h0: ALU_Control = `ALU_Control_ADD; //add
//             3'h7: ALU_Control = `ALU_Control_AND; //and
//             3'h6: ALU_Control = `ALU_Control_OR; //or
//             3'h4: ALU_Control = `ALU_Control_XOR; //xor
//             3'h1: ALU_Control = `ALU_Control_Shift_Left; //shift left
//             3'h5: ALU_Control = (fun7==0)?`ALU_Control_Shift_Right_U:(fun7==7'h20)?`ALU_Control_Shift_Right:0; //shift right_U shift right
//             3'h3: ALU_Control = `ALU_Control_Set_Less_U; //set less than_U
//             3'h2: ALU_Control = `ALU_Control_Set_Less; //set less than 
//         endcase

//     endcase
// end
// endmodule

//ecall



// module ALU_tb;
//     reg [3:0]  ALUControl;
//     reg [1:0]  ALUSrc;
//     reg [31:0] ReadData1, ReadData2, imm32;
//     wire [31:0] ALUResult;
//     wire zero;

//     ALU uut (
//         .ALUControl(ALUControl),
//         .ALUSrc(ALUSrc),
//         .ReadData1(ReadData1),
//         .ReadData2(ReadData2),
//         .imm32(imm32),
//         .ALUResult(ALUResult),
//         .zero(zero)
//     );

//     initial begin
//         $dumpfile("ALU.vcd");  // 指定输出的波形文件名
//         $dumpvars;
//         // 初始化
//         ReadData1 = 32'd10;
//         ReadData2 = 32'd5;
//         imm32     = 32'd3;

//         // 测试 ADD: ReadData1 + ReadData2
//         ALUControl = 4'b0010;
//         ALUSrc     = 2'b00;
//         #10;
//         $display("ADD: %d", ALUResult);

//         // 测试 SUB: ReadData1 - ReadData2
//         ALUControl = 4'b0110;
//         ALUSrc     = 2'b00;
//         #10;
//         $display("SUB: %d", ALUResult);

//         // 测试 AND: ReadData1 & ReadData2
//         ALUControl = 4'b0000;
//         ALUSrc     = 2'b00;
//         #10;
//         $display("AND: %d", ALUResult);

//         // 测试 OR: ReadData1 | ReadData2
//         ALUControl = 4'b0001;
//         ALUSrc     = 2'b00;
//         #10;
//         $display("OR: %d", ALUResult);

//         // 测试立即数：ReadData1 + imm32
//         ALUControl = 4'b0010;
//         ALUSrc     = 2'b01;
//         #10;
//         $display("ADD with imm: %d", ALUResult);

//         // 测试 zero flag
//         ReadData1 = 32'd10;
//         ReadData2 = 32'd10;
//         ALUControl = 4'b0110; // SUB
//         ALUSrc     = 2'b00;
//         #10;
//         $display("Zero flag: %b", zero);

//         $finish;
//     end
// endmodule
