main:
  # syscall used for input/output !!!
  addi $sp, $sp, -8 # to save input and return address
  li $a3, 1
  
  sw $ra, 4($sp)
  sw $s0, 0($sp)
  
  li $v0, 5 #read an integer   1 when reading it
  syscall
  
  move $s0, $v0 # make y the input
  
  add $s0, $s0, $a3 # y++
  
  
main_loop:
  #li $s4, 1
  move $a0, $s0
  jal helper 
  
  beqz $v0, increment
  
  j finished_now


increment:
  li $a3, 1
  add $s0, $s0, $a3
  j main_loop  
      
  
finished_now:
  move $a0, $s0
  li $v0, 1
  syscall
  
  #restore everything as it was before
  #j restore

 restore:
   lw $s0, 0($sp)
   lw $ra, 4($sp)
   addi $sp, $sp, 8
   li $v0, 10
   syscall  
  
  
helper:
  #save the input and make operations
  addi $sp, $sp, -4
  sw $s1, 0($sp)
  
  li $t0, 1000
  li $t1, 100
  li $t2, 10
  
  div $a1, $a0, $t0 # n/1000
  
  div $a2, $a0, $t1 # (n/100) 
  rem $a2, $a2, $t2 # (n/100) % 10
  
  div $a3, $a0, $t2 # n/10
  rem $a3, $a3, $t2 # (n/10) % 10
  
  rem $s1, $a0, $t2 # n % 10
  
  beq $a1, $a3, bad_case
  beq $a1, $s1, bad_case 
  beq $a1, $a2, bad_case
  beq $a3, $s1, bad_case
  beq $a2, $a3, bad_case  
  beq $a2, $s1, bad_case
      
  li $v0, 1
  j completed
        
        
bad_case:
   li $v0, 0


completed:
  lw $s1, 0($sp)
  addi $sp, $sp, 4
  jr $ra