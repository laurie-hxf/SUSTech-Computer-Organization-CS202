.data # Demo1 ：1/3
# 32*2 word (rows: 2, columns: 32)
matrix: .space 256

.macro getindex(%ans,%i,%j)
	slli %ans,%i,5       # i * 32
	add  %ans,%ans,%j    # i*32 + j
	slli %ans,%ans,2     # *4 (word size)
.end_macro

.text
	addi t0,x0,0     # i = 0
	addi s0,x0,2     # s0 = 2 (row bound)
	addi t1,x0,0     # j = 0
	addi s1,x0,32    # s1 = 32 (col bound)
	la t6, matrix    # base address of matrix

loopi:
	beq t0,s0,loopiend
	addi t1,x0,0

loopj:
	beq t1,s1,loopjend

	getindex(a0,t0,t1)
	add a1,t0,t1         # generate some value to store
	add t5,t6,a0         # compute final address
	sw a1,0(t5)          # store into matrix[i][j]

	addi t1,t1,1
	j loopj

loopjend:
	addi t0,t0,1
	j loopi

loopiend:
	li a7,10
	ecall
