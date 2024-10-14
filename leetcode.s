.data
test0: .word   4,8,2,10
test1: .word   1,3,4,8
test2: .word   1,2,3,4 
space: .string " "
newline: .string "\n" 
queries: .word 0,3,0,1 

.text
main:
    la a1,test0            # a1=arr[]
    addi a2,x0,5           # a2=arrsize + 1
    la a3,queries          # a3=queries[]
    jal ra initial
    
    la  a1,test1           # a1=arr[]
    addi a2,x0,5           # a2=arrsize + 1
    la a3,queries          # a3=queries[]
    addi a2,x0,5
    la a3,queries
    jal ra initial
    
    la  a1,test2           # a1=arr[]
    addi a2,x0,5           # a2=arrsize + 1
    la a3,queries          # a3=queries[]
    la a3,queries
    jal ra initial
    j Exit
    
initial:   
    addi sp, sp, -28       # allocate for prefix loop                     
    sw   s4,0(sp)          # store prefix[0] in stack
    addi a5, sp, 0 
    addi t0 zero,1         # set i=1
    j prefix_loop
    
prefix_loop:
    bge t0, a2, prefix_done # if i >= arrsize, exit loop
    lw t1,0(a1)            # load value of arr[i-1]
    addi a1,a1,4           # move to next element in arr
    lw t2, 0(a5)           # load value of prefix[i-1]
    xor t2, t1, t2         # prefix[i]=arr[i-1]^prefix[i-1]
    addi a5,a5,4           # move to next space in prefix
    sw t2, 0(a5)           # store prefix[i]
    addi t0, t0, 1         # i++
    j prefix_loop
    
prefix_done:  
    addi s6, x0, 4         # queriesSize = 4
    # Compute results for each query
    addi t0, x0, 0         # Initialize loop index for queries to 0
    j queries_loop
queries_loop:
    bge t0,s6 ,print # If loop index >= queriesSize, exit loop
    lw t1, 0(a3)           # Load left value of query
    lw t2, 4(a3)           # Load right value of query
    addi a3, a3, 8         # Increment queries pointer to the next query

    slli t1, t1, 2         # Calculate byte offset for prefix[left]
    add  t3, sp, t1        # Address of prefix[left]
    lw   s7, 0(t3)         # load prefix[left]
    addi t2, t2, 1         # right + 1
    slli t2, t2, 2         # calculate byte offset for prefix[right + 1]
    add  t4 ,sp ,t2        # address of prefix[right + 1]
    lw   s8 ,0(t4)         # load prefix[right + 1]
    xor  s8,s7,s8          # result = prefix[right + 1] ^ prefix[left]
    addi t0, t0, 2         # move to next query
    addi a0, s8,0          # Load result[t0] into a0
    li a7, 1               # syscall code for print integer
    ecall 
    la a0 ,space
    li a7 ,4               # syscall code for print string
    ecall
    j queries_loop
    
print:
    addi sp, sp, 28        # Restore stack pointer
    la a0 ,newline
    li a7,4
    ecall
    ret
Exit:
    li a7,10
    ecall