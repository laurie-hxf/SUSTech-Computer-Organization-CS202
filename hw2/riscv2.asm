.data
	one_e_minus_6: .double 1.0e-6  # 定义 1e-6
.text
main:
	li a7,7
	ecall
	fmv.d ft0,fa0	#a
	
	li a7,7
	ecall
	fmv.d ft1,fa0	#x1
	
	li a7,7
	ecall
	fmv.d ft2,fa0	#x2
	
	li t4, 2             
    	fcvt.d.w ft4, t4     # 转换整数 2 为 double（存入 fa1）
    	
    	li t6, 0            
    	fcvt.d.w ft7, t6     # 转换整数 0 为 double（存入 fa1）
	
loop:
	fadd.d ft3,ft1,ft2
	fdiv.d	ft3,ft3,ft4
	fmul.d ft6,ft3,ft3	#x3^2
	fsub.d ft6,ft6,ft0	#f(x3)
	
	fmul.d ft5,ft1,ft1	#x1^2
	fsub.d ft5,ft5,ft0	#f(x1)
	
	fmul.d ft5,ft5,ft6
	
	flt.d t1, ft5, ft7  # 如果 fa0 < 0.0，则 t1 = 1，否则 t1 = 0
    	bnez t1, changex2  # 如果 t1 = 1，跳转到 equal_zero
    
	#bltz ft5,changex2
	fmv.d ft1,ft3
	j last
	
changex2:
	fmv.d ft2,ft3	
	
last:
	fabs.d ft6, ft6
	la t0, one_e_minus_6  # 加载 1e-6 的地址
    	fld fa1, 0(t0)        # 读取 1e-6 到 fa1
    	
        flt.d t1, ft6, fa1    # 如果 fa0 < fa1 (1e-6)，t1 = 1，否则 t1 = 0
    	beqz  t1, loop    # 如果 t1 = 1，跳转到 less_than	
    	
    	fmv.d fa0,ft3
    	li a7,3
	ecall
	
		
	li a7,10
	ecall