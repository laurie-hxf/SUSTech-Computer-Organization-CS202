.include "macro_print_str.asm"

.data
dividend:    .word -421          # 被除数（32位，最高位为符号位）
divisor:     .word -7          # 除数（32位）
exceptionStr:.asciiz "Division by zero!\n"
newLine:     .asciiz "\n"

.text

main:

    la      t5, dividend
    lw      t1, 0(t5)        # t1 = dividend
    la      t5, divisor
    lw      t2, 0(t5)        # t2 = divisor

    beq     t2, zero, divZero   # 若除数为0，跳转异常处理

    # 保存原始的 dividend 和 divisor（用于符号判断）
    add     s8, t1, zero        # t8 保存原始 dividend
    add     s9, t2, zero        # t9 保存原始 divisor


    srai    t3, t1, 31       # t3 = dividend 符号扩展 (0 或 -1)
    srai    t4, t2, 31       # t4 = divisor 符号扩展

    # 若 dividend 为负，求其绝对值
    bgez    t1, abs_dividend_done
    sub     t1, zero, t1
abs_dividend_done:
    # 若 divisor 为负，求其绝对值
    bgez    t2, abs_divisor_done
    sub     t2, zero, t2
abs_divisor_done:


    # 初始化：t6 保存商，t7 保存余数（初始为0）
    add     t6, zero, zero
    add     s7, zero, zero

    li      t0, 32         # 循环 32 次

div_loop:
    # 将余数左移1位，并将 dividend 的最高位移入余数最低位
    slli    s7, s7, 1

    # 提取 t1 的最高位：将 t1 与 0x80000000 与后非零则说明该位为1
    li      s10, 0x80000000
    and     s11, t1, s10
    beq     s11, zero, no_bit
    li      s11, 1
no_bit:
    or      s7, s7, s11

    # 将 dividend 左移1位，为下一次循环准备
    slli    t1, t1, 1

    # 试减：余数减除数
    sub     s3, s7, t2
    # 如果结果 < 0，则说明本位商为 0，恢复余数（不更新 t7）
    bltz    s3, restore_remainder

    # 若不为负，更新余数=t12，同时商该位置 1
    add     s7, s3, zero
    slli    t6, t6, 1
    addi    t6, t6, 1
    j       div_next

restore_remainder:
    slli    t6, t6, 1    # 商该位置 0（不用加1）

div_next:
    addi    t0, t0, -1
    bnez    t0, div_loop


    # 商的符号：若原 dividend 与 divisor 符号不同，则商取负
    xor     s1, t3, t4   # 若 t3 与 t4 异号，则 t13 非0
    bnez    s1, neg_quotient
    j       adjust_remainder

neg_quotient:
    sub     t6, zero, t6

adjust_remainder:
    # 余数的符号与原 dividend 保持一致
    srai    s2, s8, 31   # t14 为原 dividend 的符号
    bltz    s8, neg_remainder
    j       output_result
neg_remainder:
    sub     s7, zero, s7


output_result:
    # 输出商
    mv      a0, t6
    li      a7, 1         # 打印整型数
    ecall

    # 换行
    #la      a0, newLine
    #li      a7, 4
    #ecall
    
    print_string("\n")

    # 输出余数
    mv      a0, s7
    li      a7, 1
    ecall

    li      a7, 10        # 退出
    ecall

    # ---------------------------
    # 除数为 0 时的异常处理
divZero:
    print_string("Division by zero")
    li      a7, 10
    ecall
