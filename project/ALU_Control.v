`include "define.v"

module ALU_Control(
    input [3:0] ALU_Op,
    input [6:0] fun7,
    input [2:0] fun3,
    output reg [3:0] ALU_Control
);

always @ * begin
    case(ALU_Op)
    `ALU_OP_LW,`ALU_OP_SW: ALU_Control = `ALU_Control_ADD;
    `ALU_OP_B: ALU_Control = `ALU_Control_SUB;
    `ALU_OP_LUI: ALU_Control = `ALU_Control_Lui;
    `ALU_OP_AUIPC: ALU_Control = `ALU_Control_Auipc;
    `ALU_OP_J: ALU_Control = `ALU_Control_J;
    `ALU_OP_R:
        case({fun7,fun3})
            10'b0000000_000: ALU_Control = `ALU_Control_ADD; //add
            10'b0100000_000: ALU_Control = `ALU_Control_SUB; //sub
            10'b0000000_111: ALU_Control = `ALU_Control_AND; //and
            10'b0000000_110: ALU_Control = `ALU_Control_OR; //or
            10'b0000000_100: ALU_Control = `ALU_Control_XOR; //xor
            10'b0000000_001: ALU_Control = `ALU_Control_Shift_Left; //shift left
            10'b0000000_101: ALU_Control = `ALU_Control_Shift_Right_U; //shift right_U
            10'b0100000_101: ALU_Control = `ALU_Control_Shift_Right; //shift right
            10'b0000000_011: ALU_Control = `ALU_Control_Set_Less_U; //set less than_U
            10'b0000000_010: ALU_Control = `ALU_Control_Set_Less; //set less than 
        endcase
    `ALU_OP_I:
        case(fun3)
            3'h0: ALU_Control = `ALU_Control_ADD; //add
            3'h7: ALU_Control = `ALU_Control_AND; //and
            3'h6: ALU_Control = `ALU_Control_OR; //or
            3'h4: ALU_Control = `ALU_Control_XOR; //xor
            3'h1: ALU_Control = `ALU_Control_Shift_Left; //shift left
            3'h5: ALU_Control = (fun7==0)?`ALU_Control_Shift_Right_U:(fun7==7'h20)?`ALU_Control_Shift_Right:0; //shift right_U shift right
            3'h3: ALU_Control = `ALU_Control_Set_Less_U; //set less than_U
            3'h2: ALU_Control = `ALU_Control_Set_Less; //set less than 
        endcase

    endcase
end
endmodule

//ecall