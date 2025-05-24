.data
	
.text
main:
start:
    lb t0, 0xfffffc64 #读取确认按钮
    beq t0,zero,start
    
    # 读取测试用例输入
    lb x11,0xffffc14  

    # 选择跳转到不同测试用例
    li x12, 0
    beq x11, x12, test0
    
    li x12, 1
    beq x11, x12, test1
    
    li x12, 2
    beq x11, x12, test2
    
    li x12, 3
    beq x11, x12, test3
    
    li x12, 4
    beq x11, x12, test4
    
    li x12, 5
    beq x11, x12, test5
    
    li x12, 6
    beq x11, x12, test6
    
    li x12, 7
    beq x11, x12, test7
    
    j start     # 未匹配 → 回到主循环

test0:
    lb t0, 0xfffffc64 #读取确认按钮
    beq t0,zero,test0
    
    lb t1, 0xfffffc14 #读取测试数据输入
    sb t1, 0xfffffcbc #led
    
temp:
    lb t0, 0xfffffc64 #读取确认按钮
    beq t0,zero,temp
    
    lb t1, 0xfffffc14 #读取测试数据输入
    sb t1, 0xfffffcbc #led
    j start     # 回到主循环
    

test1:
    lb t0, 0xfffffc64 #读取确认按钮
    beq t0,zero,test1
    
    lb t1, 0xfffffc14 #读取测试数据输入
    sb t1, 0xfffffcbc #数码管
    sb t1, 0x10010000 #存到内存
    j start     # 回到主循环

test2:
    lb t0, 0xfffffc64 #读取确认按钮
    beq t0,zero,test2
    
    lb t1, 0xfffffc14 #读取测试数据输入
    sb t1, 0xfffffc72 #数码管
    sb t1, 0x10010004 #存到内存
    
    j start
    
test3:
    
    j start
test4:
    
    j start
test5:
    
    j start
test6:
    
    j start
test7:
    
    j start
