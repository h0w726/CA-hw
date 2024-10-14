.data 
test0: .word 0xBFB9999A #-1.45 in fp32
test1: .word 0x40233333 # 2.55 in fp32
test2: .word 0xC07F5C29 #-3.99 in fp32
newline: .string "\n"
    
.text
main:
    la s0 ,test0             # load address of test0
    lw t0 ,0(s0)
    jal fp32_to_bf16
    
    la s0 ,test1             # load address of test1
    lw t0 ,0(s0)
    jal fp32_to_bf16
    
    la s0 ,test2             # load address of test2
    lw t0 ,0(s0)
    jal fp32_to_bf16
    
    j Exit
    
fp32_to_bf16:
    li t1,0x7fffffff         # t1 = 0x7fffffff
    li t2,0x7f800000         # t2 = 0x7f800000
    and t3,t1,t0             # u.i & 0x7fffffff

    bge t3,t2 Else           # NaN go to Else
    srli t4,t0,0x10          # t4 = u.i >> 0x10
    andi  t4,t4,1            # t4 &1
    li t5,0x7fff             # t5 = 0x7fff
    add t4,t5,t4             # t4 = (0x7fff + ((u.i >> 0x10) & 1))
    add t4,t0,t4             # t4 = (u.i + (0x7fff + ((u.i >> 0x10) & 1)))
    srli t4,t4,0x10          # t4 = (u.i + (0x7fff + ((u.i >> 0x10) & 1))) >> 0x10;
    addi a0,t4,0
    j print
    jr ra
    
    Else:   
    srli t4,t0,0x10          # t4 = (u.i >> 16) 
    ori  t4,t4,64            # t4 = (u.i >> 16) | 64;
    addi a0,t4,0
    j print
    jr ra
    
print:
    li a7 ,1                 # syscall code for print integer
    ecall
    la a0,newline
    li a7,4                  # syscall code for print string
    ecall
    ret
Exit: 
    li a7,10 
    ecall  