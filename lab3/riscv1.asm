.include "macro_print_str.asm"
.data
.text
main:
	print_string("Please input an integer: \n")
	li a7, 5
	ecall
	
	mv t0, a0
	slli t2,t0,31
	beq t2,x0,even
	print_string("It is an odd number (0: false,1: true): ")
	mv a0, t0
	li a7, 1
	ecall
	
	end
	
	
even:	
	print_string("It is an even number (0: false,1: true): ")
	mv a0, t0
	li a7, 1
	ecall
	
	end
