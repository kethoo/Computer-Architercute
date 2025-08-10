
.data
prompt: .asciiz "Enter two integers: "  # prompt message
a:      .word 0                        # space for integer a
b:      .word 0                        # space for integer b
	 .text
        .globl main

        
main:
	jal reading_input
	

	
	
	li $t0, 1 # result size
	li $t1, 100 # size of array
	li $t2, 0 #i
	addi $sp, $sp, -400 # for 100 ints
	
	main_for:		
	bge $t2, $t1, finish_running
	mul $t3, $t2, 4
	
	add $t3, $t3, $sp # t3 is the ith member of the array
	sw $t0, 0($t3)
	addi $t2, $t2, 1
	j main_for
	 
	finish_running:

	li $t2, 1
	la $t3, b
	lw $t3, 0($t3) # b is in t3
	
	for_01:
	bgt $t2, $t3 , out_for_01
	
	# a0 carry
	# a1 temp
	li $a0, 0 # carry =0
	li $t4, 0 # j=0  
	for_02:
	bge $t4, $t0, while
	
	mul $t5, $t4, 4 #  4 * j
	add  $t5, $t5, $sp # t5 = t5 +sp
	
	lw $t6, 0($t5)
	
	la $t7, a
	lw $t7, 0($t7) # b is in t3
	
	mul $t6, $t6, $t7 # result[j] * a
	add $t6, $t6, $a0 # temp
	
	li $s0, 10 
	div $t6, $s0
	mfhi $s1
	mflo $a0
	
	sw $s1,($t5) 
	addi $t4, $t4, 1
	
	j for_02
		 
	while:
	beqz $a0, out_while
	mul $t4, $t0, 4 #  4 * result_size
	add  $t4, $t4, $sp # result[result_size]
	
	li $s0, 10 
	div $a0, $s0
	mfhi $s1 #carry%10
	mflo $a0 #carry/10
	
	sw $s1, 0($t4)
	addi $t0, $t0, 1
	j while
	
	out_while:
	addi $t2, $t2 ,1
	j for_01
	out_for_01:
	addi $t2, $t0, -1
	
	final_for:
	bltz $t2, final_out
	mul $t4, $t2, 4
	add $t4, $t4, $sp
	
	lw $a0, 0($t4)
	li $v0, 1
	syscall 
	
	addi $t2, $t2, -1
	j final_for
	
	
	final_out:
	addi $sp, $sp, 400
	li $v0, 10
	syscall
	
	
reading_input :

	li $v0, 5                       
        syscall
        sw $v0, a                      

        li $v0, 5                       
        syscall
        sw $v0, b                       

        jr $ra       