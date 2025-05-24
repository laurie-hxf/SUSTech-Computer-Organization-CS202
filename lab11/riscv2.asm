.data # Demo2 ：1/3
# 32*2 word (rows: 2, columns: 32)
matrix: .space 256

.macro getindex(%ans,%i,%j)
    slli %ans,%i,5       # i * 32
    add  %ans,%ans,%j    # i*32 + j
    slli %ans,%ans,2     # *4 (word size)
.end_macro

.text
    addi t0,x0,0         # i
    addi s0,x0,2         # 2 rows
    addi t1,x0,0         # j
    addi s1,x0,32        # 32 cols
    la t6, matrix        # base address

loopj:
    beq t1,s1,loopjend

    addi t0,x0,0
loopi:
    beq t0,s0,loopiend

    getindex(a0, t0, t1)
    add t5, t6, a0
    add a1, t0, t1       # data to store
    sw a1, 0(t5)

    addi t0, t0, 1
    j loopi

loopiend:
    addi t1, t1, 1
    j loopj

loopjend:
    li a7,10
    ecall
