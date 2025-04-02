module subtraction(in1,in2,result,overflow);
input [2:0]in1,in2;
output [2:0] result;
output overflow;
assign result = in1 - in2;
assign overflow = 
( in1[2] & ~in2[2] & ~result[2] ) | /* two +ve operands, get -ve operand*/
(~in1[2] & in2[2] & result[2] ); /* two -ve operands, get +ve operand*/;
endmodule

module subtractionTb; //verilog
reg [2:0] in1,in2;
wire overflow;
wire [2:0] sum;
subtraction ua(in1,in2,sum,overflow);

initial begin
$dumpfile("partise1-2.vcd");  // 指定输出的波形文件名
$dumpvars;
{in1,in2} = 6'b0;
repeat(63) #10 {in1,in2} = {in1,in2} + 1;
#10 $finish;
end
endmodule