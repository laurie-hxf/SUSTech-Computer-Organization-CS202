`define ALU_OP_R 4'b0000
`define ALU_OP_I 4'b0001

`define ALU_OP_LW 4'b0010
`define ALU_OP_SW 4'b0011

`define ALU_OP_B 4'b0100

`define ALU_OP_J 4'b0101

`define ALU_OP_LUI 4'b0110

`define ALU_OP_AUIPC 4'b0111

`define ALU_OP_ECALL 4'b1000



`define ALU_Control_ADD 4'b0000
`define ALU_Control_SUB 4'b0001
`define ALU_Control_AND 4'b0010
`define ALU_Control_OR 4'b0011
`define ALU_Control_XOR 4'b0100
`define ALU_Control_Shift_Left 4'b0101
`define ALU_Control_Shift_Right_U 4'b0110
`define ALU_Control_Shift_Right 4'b0111
`define ALU_Control_Set_Less_U 4'b1000
`define ALU_Control_Set_Less 4'b1001
`define ALU_Control_Lui 4'b1010 
`define ALU_Control_Auipc 4'b1011
`define ALU_Control_J 4'b1100


`define H_SYNC 10'd96
`define H_BACK 10'd40
`define H_LEFT 10'd8
`define H_ACTIVE 10'd640
`define H_RIGHT 10'd8
`define H_FRONT 10'd8
`define H_CYCLE 10'd800

`define V_SYNC 10'd2
`define V_BACK 10'd25
`define V_TOP 10'd8
`define V_ACTIVE 10'd480
`define V_BOTTOM 10'd8
`define V_FRONT 10'd2
`define V_CYCLE 10'd525


