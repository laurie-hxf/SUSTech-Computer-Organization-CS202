.data
.text
main:
	li a7,5
	ecall	
	mv t0,a0	#n


	li a7,5
	ecall
	mv t1,a0	#k

	
	sub a0,t0,t1	#n-k
	jal fact
	mv t2,t3
	
	mv a0,t0
	jal fact
	mv t0,t3
	
	mv a0,t1
	jal fact
	mv t1,t3
	
	mul t2,t2,t1
	div a0,t0,t2
	
	li a7,1
	ecall
	
	li a7,10
	ecall


	

fact:
	addi t3,x0,1
loop:
	beq a0,x0,jr
	mul t3,t3,a0
	addi a0,a0,-1
	bgt a0,x0,loop
	
jr:	jr ra
	
	
	