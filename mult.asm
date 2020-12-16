.data

.text
	addi $t0, $zero, 2000
	addi $t1, $zero, 4
	
	mult $t0, $t1 		# salva o resultado em lo e se for maior em hi tambem
	
	mflo $s0
	
	li $v0, 1
	add $a0, $s0, $zero
	syscall