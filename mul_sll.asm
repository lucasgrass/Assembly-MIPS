.data 

.text 
	addi $s0, $zero, 4
	
	sll $t0, $s0, 3		# t0 = s0 * (2^3)
	
	li $v0, 1
	add $a0, $t0, $zero
	syscall
	
	