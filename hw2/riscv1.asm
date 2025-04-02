.data
	
.text
main:
	li a7,5
	ecall
	mv t0,a0	#length    k
	
	fcvt.d.w ft0, t0  # convert k into double
	
	slli a0,t0,3
	li a7,9		#heap
	ecall
	
	mv t1,a0	#address of heap
	mv t2,a0	#pointer
	
	add t3, zero, zero 		#i
	add t4,zero,zero		# sum
	
loop_read:
	li a7, 7 
	ecall
	fsd fa0, 0(t2) #read the array
	fadd.d ft4,ft4,fa0
	addi t2, t2, 8
	addi t3, t3, 1
	bgt t0, t3, loop_read
	

	fdiv.d fa0,ft4,ft0
	fdiv.d ft4,ft4,ft0		#mean
	#fadd.s fa0,t4,zero
	li a7,3
	ecall
	
	li a7, 11                 # System call 11: print character
	li a0, 10                 # ASCII code 10 corresponds to newline '\n'
	ecall
	
	

	
	add t3, zero, zero	#i
	add t2,t1,zero
loop_Variance:	
	fld ft5,0(t2)
	addi t2,t2,8
	addi t3,t3,1
	
	fsub.d ft5,ft5,ft4
	fmul.d ft5,ft5,ft5
	fadd.d ft6,ft6,ft5
	bgt t0,t3,loop_Variance
	
	fdiv.d fa0,ft6,ft0
	li a7,3
	ecall
	
		
	li a7,10
	ecall
	
	