
.data
	string: .space 1000
.text
main:
	la a0,string 
	addi a1,x0,1000
	li a7,8
	ecall
	
	li a7,4
	ecall
	
	li a7,10
	ecall
	
	
	
