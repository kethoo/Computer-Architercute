.data
prompt:     .asciiz "Input the expression to calculate : "
out_dis:    .asciiz "Answer : "
newline:    .asciiz "\n"
input:      .space 50

.text
.globl main
main:
    li $v0, 4
    la $a0, prompt
    syscall
    # reading
    li $v0, 8
    la $a0, input
    li $a1, 50
    syscall
    # calculate
    la $a0, input
    jal make_calc_ez
    # output
    move $t0, $v0
    li $v0, 4
    la $a0, out_dis
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, newline
    syscall
    # exit
    li $v0, 10
    syscall

make_calc_ez:
    move $t0, $a0
    li $t6, 0
    move $t4, $t6        
    move $t3, $t6       
    move $t2, $t6       
    move $t1, $t6        
    li $t7, 0            

dam_input1:
    lb $t5, 0($t0)              # load ch
    beq $t5, $zero, calc_com
    blt $t5, 48, shex_op_now
    bgt $t5, 57, shex_op_now
    # curr is digit
    sub $t5, $t5, 48
    mul $t1, $t1, 10
    add $t1, $t1, $t5
    addi $t0, $t0, 1
    j dam_input1

shex_op_now:
    beq $t5, 43, axl_op       # +
    beq $t5, 45, axl_op       # -
    beq $t5, 42, axl_op       # *
    beq $t5, 47, axl_op       # /
    beq $t5, 32, ign_dash      # space
    beq $t5, 10, calc_com      # newline
    addi $t0, $t0, 1           # random char
    j dam_input1

axl_op:
    move $t3, $t5
    addi $t0, $t0, 1
    j dam_input2

ign_dash:
    addi $t0, $t0, 1
    j dam_input1

dam_input2:
    lb $t5, 0($t0)             # load char
    beq $t5, $zero, real_ang_calc
    beq $t5, 10, real_ang_calc   # newline
    beq $t5, 32, ig_dash       # space
    blt $t5, 48, check_next_op
    bgt $t5, 57, check_next_op
    sub $t5, $t5, 48
    mul $t2, $t2, 10
    add $t2, $t2, $t5
    addi $t0, $t0, 1
    j dam_input2

check_next_op:
    beq $t5, 43, moa_next_op  # +
    beq $t5, 45, moa_next_op  # -
    beq $t5, 42, moa_next_op  # *
    beq $t5, 47, moa_next_op  # /
    addi $t0, $t0, 1
    j dam_input2

moa_next_op:
    beq $t3, 42, jer_mag_es   #  *
    beq $t3, 47, jer_mag_es   #  /
    beq $t5, 42, mer_dab_es     # next  *
    beq $t5, 47, mer_dab_es     # next  /
    
  
    beq $t3, 43, do_add_next
    beq $t3, 45, do_sub_next
    j shemdegi_task_prior

jer_mag_es:
    
    beq $t3, 42, do_mul_next
    beq $t3, 47, do_div_next
    j shemdegi_task_prior

mer_dab_es:
    
    bne $t7, 0, chalup_ch
    move $t4, $t1       
    move $t7, $t3       
    move $t1, $t2       
    move $t3, $t5       
    li $t2, 0            
    addi $t0, $t0, 1
    j dam_input2

chalup_ch:
    beq $t7, 43, nex_add_fut
    beq $t7, 45, nex_sub_fut
    j save_current_op

nex_add_fut:
    add $t1, $t4, $t1
    j save_current_op

nex_sub_fut:
    sub $t1, $t4, $t1
    j save_current_op

save_current_op:
    
    move $t4, $t1       
    move $t7, $t3        
    move $t1, $t2       
    move $t3, $t5       
    li $t2, 0            
    addi $t0, $t0, 1
    j dam_input2

do_add_next:
    add $t1, $t1, $t2
    j shemdegi_task_prior

do_sub_next:
    sub $t1, $t1, $t2
    j shemdegi_task_prior

do_mul_next:
    mul $t1, $t1, $t2
    j shemdegi_task_prior

do_div_next:
    div $t1, $t2
    mflo $t1
    j shemdegi_task_prior

shemdegi_task_prior:
    move $t3, $t5        
    li $t2, 0            
    addi $t0, $t0, 1
    j dam_input2

ig_dash:
    addi $t0, $t0, 1
    j dam_input2

real_ang_calc:
    beq $t3, 43, final_add
    beq $t3, 45, final_sub
    beq $t3, 42, final_mul
    beq $t3, 47, final_div
    j lookat_fut

final_add:
    add $t1, $t1, $t2
    j lookat_fut

final_sub:
    sub $t1, $t1, $t2
    j lookat_fut

final_mul:
    mul $t1, $t1, $t2
    j lookat_fut

final_div:
    div $t1, $t2
    mflo $t1
    j lookat_fut

lookat_fut:
    beq $t7, 0, calc_com
    beq $t7, 43, nextul_add
    beq $t7, 45, nextul_sub
    j calc_com

nextul_add:
    add $t1, $t4, $t1
    j calc_com

nextul_sub:
    sub $t1, $t4, $t1
    j calc_com

calc_com:
    move $v0, $t1
    jr $ra
