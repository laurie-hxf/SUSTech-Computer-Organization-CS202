.data
	change: .asciz "\n"
.text
main:
	li a7,5
	ecall
	mv t0,a0	#length
	
	slli a0,t0,2
	li a7,9
	ecall
	
	mv t1,a0	#address of heap
	mv t2,a0	#pointer
	
	add t3, zero, zero 
	
loop_read:
	li a7, 5 
	ecall
	sw a0, (t2) #read the array
	addi t2, t2, 4
	addi t3, t3, 1
	bgt t0, t3, loop_read
	
	add t3, zero, zero	#i

	
for1:
	add t4,zero,zero	#j
	add t2, t1, zero 	#pointer
for2:
	lw a0,(t2)
	lw a1,4(t2)
	bge a1,a0, ja
	sw a1,(t2)
	sw a0,4(t2)
ja:	
	addi t4,t4,1
	sub t5,t0,t3
	addi t5,t5,-1
	addi t2,t2,4
	blt t4,t5,for2
	
	
	
	addi t3,t3,1
	addi t5,t0,0
	blt t3,t5,for1
	
	
	mv t2,t1	#pointer
	add t3, zero, zero 
	
loop_print:
	lw a0,(t2)
	li a7,1
	ecall
	
	la a0,change
	li a7,4
	ecall
	
	addi t2, t2, 4
	addi t3, t3, 1
	bgt t0, t3, loop_print
	
	
	li a7,10
	ecall
	
	
	