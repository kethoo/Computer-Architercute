
	
	
main:	
	#jal read_input
	jal read_n
	move $a3,$v0 #move n into a3
	
	jal read_m
	move $a2,$v0 #move m into a2
	
	jal calculations
	
	move $a0, $v0 #put the answer in a0
	
	li $v0, 1 #for outputting
	syscall
	
	li $v0, 10 #exit my code
	syscall

read_n:
	li $v0, 5 #input n
	syscall
	jr $ra
	
read_m:
	li $v0,5 #input m
	syscall
	jr $ra
	
devide_by_two:
	li $t5, 2 #keep it for devision 
   	div $t2, $t5    
    	mflo $t2 #load LO in t2        
    	jr $ra   

increase_ans:
	li $t7, 1				
	add $t1, $t1, $t7 # ans++ and saved in t2
	jr $ra
	
calculations:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t3, $a3 #move n into t3
	move $t2, $a2 #move m into t2
	li $t1, 0     #intitiate t1 to 0, this is the final ans
	li $t7, 1
	
cycle_body:
	bge $t3, $t2, finish_cycle
	
	#if m is even
	li $t5, 2 #load 2 into t5 to check if even/odd
	rem $t6, $t2, $t5 #load remainder in t6 and check it
	beqz $t6, its_even
	
	#if m is odd
	add $t2, $t7,$t2
	
	#increase ans
	jal increase_ans
	j cycle_body

its_even:
	jal devide_by_two
	jal increase_ans
	j cycle_body		

finish_cycle:
	sub $t4, $t3, $t2# find n-m
	add $t1, $t4, $t1# ans + (n-m)
	move $v0, $t1
	
	
	lw $ra, 0($sp)
	addi $sp,$sp,4
	
	jr $ra #return to return address
	

	 	 

	
	
	
	







