module adder (in1, in2, sum, overflow); 
input [2:0]in1, in2;
output [2:0] sum;
output overflow;
//in verilog
assign sum = in1 + in2;
assign overflow =
( in1[2] & in2[2] & ~sum[2] ) | /* two +ve operands, get -ve operand*/
(~in1[2] & ~in2[2] & sum[2] ); /* two -ve operands, get +ve operand*/
endmodule

module adderTb; //verilog
reg [2:0] in1,in2;
wire overflow;
wire [2:0] sum;
adder ua(in1,in2,sum,overflow);

initial begin
$dumpfile("partise1-1.vcd");  // 指定输出的波形文件名
$dumpvars;
{in1,in2} = 6'b0;
repeat(63) #10 {in1,in2} = {in1,in2} + 1;
#10 $finish;
end
endmodule