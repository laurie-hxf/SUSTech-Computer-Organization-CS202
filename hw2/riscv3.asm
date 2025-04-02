.data
	one_e_minus_6: .double 1.0e-6  # 定义 1e-6
.text
main:
	li a7,7
	ecall
	fmv.d ft0,fa0	#a
	
	li a7,7
	ecall
	fmv.d ft1,fa0	#current
	
	li t4, 2             
    	fcvt.d.w ft4, t4     # 转换整数 2 为 double（存入 fa1）
    	
 loop:
	fdiv.d ft2,ft0,ft1
	fadd.d ft2,ft2,ft1
	fdiv.d ft2,ft2,ft4
	
	fsub.d ft3,ft2,ft1
	fabs.d ft3,ft3
	
	la t0, one_e_minus_6  # 加载 1e-6 的地址
    	fld fa1, 0(t0)        # 读取 1e-6 到 fa1
    	
        flt.d t1, ft3, fa1    # 如果 fa0 < fa1 (1e-6)，t1 = 1，否则 t1 = 0
    	bnez   t1, exit    # 如果 t1 = 1，跳转到 less_than	
	
	fmv.d ft1,ft2
	j loop
	
exit:
	fmv.d fa0,ft1
	li a7,3
	ecall
	
	li a7,10
	ecall
	
	
	
	