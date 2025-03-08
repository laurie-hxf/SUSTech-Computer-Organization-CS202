.include "macro_print_str.asm"
.data
	char: .space 1
.text
main:
	print_string("Please input an char: \n")
	li a7,8 	# to get a string
	la a0,char
	li a1,2
	ecall
	
	lb t0,0(a0)      
	andi t1,t0,0xf	#low 4 bits of string
	srli  t2,t0,4    #high 4 bits of string
	mv t4,x0
	mv t0,x0	#i
	addi t5,x0,4	#end_condition
	

loop:
	addi t0,t0,1	#i++
	andi t3,t1,0x1
	slli  t4,t4,1
	add t4,t4,t3
	srli t1,t1,1
	blt t0,t5,loop
	

	beq t4,t2,equal
	print_string("\nno")
	
	end
	
equal: 
	print_string("\nyes")
	
	end

	
	
	
