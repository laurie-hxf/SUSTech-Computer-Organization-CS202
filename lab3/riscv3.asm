.include "macro_print_str.asm"
.data
.text
main:
	print_string("input a integer between 1-9\n")
	li a7,5		#read int
	ecall
	
	mv t0,a0        #move
	mv t1,x0	#i
	mv t2,x0	#j
	
loop1:
	addi t2,t2,1	#j++
loop2:
	addi t1,t1,1	#i++
	mul t3,t1,t2	#i*j
	
	mv a0, t1
	li a7, 1
	ecall	
	print_string(" * ")
	mv a0, t2
	li a7, 1
	ecall	
	print_string(" = ")
	mv a0, t3
	li a7, 1
	ecall	
	print_string("	")
	
	blt t1,t2,loop2
	mv t1,x0
	print_string("\n")
	
	blt t2,t0,loop1
	
	end