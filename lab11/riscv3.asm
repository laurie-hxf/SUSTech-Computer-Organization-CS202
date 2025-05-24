.data #Demo2
mblk: .word 0:64
.text
add t0,x0,x0
add s0,x0,x0
addi t1,x0,32
la t5,mblk
loop:
lw t2,0(t5)
add t2,t2,t0
srli t2,t2,31
addi t0,t0,4
addi t5,t5,4
sw t2,0(t5)
addi t0,t0,4
addi s0,s0,1
bne s0,t1,loop
li a7,10
ecall