.include "macro_print_str.asm"
.text
main:
    print_string "Please enter an integer: "

    li a7, 5                   # 读取整数到a0
    ecall
    jal fib                    # 调用斐波那契函数

    li a7, 1                   # 打印结果
    ecall
    end

fib:
    addi sp, sp, -12           # 分配12字节栈空间（保存ra/a0/t1）
    sw ra, 8(sp)               # 保存返回地址
    sw a0, 4(sp)               # 保存当前n值

    # 判断是否进入递归分支
    li t0, 2                   # 使用临时寄存器t0代替s寄存器
    blt a0, t0, base_case      # if n < 2，跳转到基础情况

    # 计算fib(n-1)
    addi a0, a0, -1
    jal fib
    sw a0, 0(sp)               # 保存fib(n-1)结果到栈

    # 计算fib(n-2)
    lw a0, 4(sp)               # 恢复原n值
    addi a0, a0, -2
    jal fib

    # 计算总和
    lw t1, 0(sp)               # 取出fib(n-1)
    add a0, a0, t1             # a0 = fib(n-2) + fib(n-1)

    lw ra, 8(sp)               # 恢复返回地址
    addi sp, sp, 12            # 恢复栈指针
    jr ra

base_case:
    li a0, 1                   # F(0)和F(1)都返回1
    lw ra, 8(sp)               # 恢复返回地址
    addi sp, sp, 12            # 恢复栈指针
    jr ra