.globl __start
.text
.align 4

__start:
        la t0, Input_data  #t0 = InputData[32];
        la t1, Output_data #t1 = OutputData[32];
        li t2, 32
        li t3, 0
        
arrcpy:                       #for(t3 =0; t3 < 32; t3++)
        lw s0, 0(t0)          #    OutputData[t3] = InputData[t3];
        sw s0, 0(t1)          # This section copies the 'input data' to 'output data'. 
        addi t3, t3, 1
        addi t0, t0, 4
        addi t1, t1, 4
        beq t3, t2, arrsort
        j arrcpy
arrsort:
        la t0, Output_data         #Very primitive sorting
        li t1, 0                   #for(i =0; i< 32; i++)
        li t3, 128                 #    for(j=0; j< 32; j++)
loop1:                             #         if(OutputData[i] > OutputData[j])
        beq t1, t3 , endloop       #                swap(OutputData[i], OutputData[j]);
        li t2, 0                   # t1 = i, t2 = j, t0 = OutputData
loop2:                             # The arraysort section sorts the datas in 'output data'. 
        beq t2, t3, endloop2
        add t4, t0, t1
        add t5, t0, t2
        lw s0, 0(t4)
        lw s1, 0(t5)
        ble s0, s1, skip
        sw s0, 0(t5)
        sw s1, 0(t4)
skip:
       addi t2, t2, 4
       j loop2    
endloop2:   
        addi t1, t1, 4
        j loop1
endloop:
        ret

.data
.align 4
Input_data: .word 2, 0, -7, -1, 3, 8, -4, 10
 .word -9, -16, 15, 13, 1, 4, -3, 14
 .word -8, -10, -15, 6, -13, -5, 9, 12
 .word -11, -14, -6, 11, 5, 7, -2, -12
Output_data: .word 0, 0, 0, 0, 0, 0, 0, 0
 .word 0, 0, 0, 0, 0, 0, 0, 0
 .word 0, 0, 0, 0, 0, 0, 0, 0
 .word 0, 0, 0, 0, 0, 0, 0, 0