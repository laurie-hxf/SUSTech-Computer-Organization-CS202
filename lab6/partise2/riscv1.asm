.data
m1: .half  -1234      # 示例被乘数（16位，最高位为符号位）
m2: .half  -4567       # 示例乘数

.text

main:
    # 加载16位带符号操作数，并自动扩展到32位
    lh      t0, m1          # t0 = multiplicand
    lh      t1, m2          # t1 = multiplier

    # 保存原始符号：将最高位扩展出来（0或-1）
    srai    t3, t0, 15      # t3 = sign of multiplicand (0 if positive, -1 if negative)
    srai    t4, t1, 15      # t4 = sign of multiplier

    # 若负则求绝对值：如果 t0 < 0, t0 = -t0
    bltz    t0, abs1
    j       cont1
abs1:
    sub     t0, zero, t0
cont1:
    bltz    t1, abs2
    j       cont2
abs2:
    sub     t1, zero, t1
cont2:
    # 初始化乘积寄存器 t2 = 0，计数器 t5 = 0
    add     t2, zero, zero
    li      t5, 0

mult_loop:
    li      s1, 1
    and     s2, t1, s1      # 检查乘数最低位
    beq     s2, zero, skip_add
    add     t2, t2, t0      # 如果为1则加上当前被乘数
skip_add:
    slli    t0, t0, 1       # 被乘数左移1位
    srli    t1, t1, 1       # 乘数逻辑右移1位
    addi    t5, t5, 1
    li      t6, 16
    blt     t5, t6, mult_loop

    # 调整符号：如果原来两个操作数符号不同，则乘积应为负
    xor     s7, t3, t4      # 若异号，则最高位不同，t7 != 0
    bnez    s7, neg_result
    j       finish

neg_result:
    sub     t2, zero, t2    # 取反

finish:
    mv      a0, t2          # 将结果传递给 a0

    # 以下为系统调用打印结果（例如使用 Linux 的 ecall 调用打印整型数）
    li      a7, 1           # print integer
    ecall

    li      a7, 10          # exit
    ecall