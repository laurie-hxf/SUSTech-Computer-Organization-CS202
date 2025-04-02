.data
	
.text
main:
	li a7,7
	ecall
	fmv.d ft0,fa0	#precision
	
	
	li t1, 1            
    	fcvt.d.w ft1, t1     # sum
    	
    	#fmv.d ft2,ft1	#i 
    	fmv.d ft3,ft1	#i 
    	fmv.d ft4,ft1	# number 1
    	
    	
    	
 loop:
 	fadd.d ft2,ft4,ft2
 	fmul.d ft3,ft3,ft2
 	fdiv.d ft5,ft4,ft3
 	fadd.d ft1,ft1,ft5
 	
 	
 	flt.d t1, ft5, fa0    # 如果 fa0 < fa1 (1e-6)，t1 = 1，否则 t1 = 0
    	bnez   t1, exit    # 如果 t1 = 1，跳转到 less_than	

	j loop
	
exit:
	fmv.d fa0,ft1
	li a7,3
	ecall
	
	li a7,10
	ecall
	
	
	
	
