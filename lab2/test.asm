# Piece 2-10
.data
	str: .ascii "\nWelcome "
	sid: .space 9
	e1: .asciz " to RISC-V World"
.text
main:
	li a7, 8 # to get a string
	la a0, sid
	li a1, 9
	ecall
	
	#complete code here
	
	########
	
	li a7, 4 
	la a0, str
	ecall
	
	li a7, 4 
	la a0, e1
	ecall
	
	li a7, 10 
	ecall

