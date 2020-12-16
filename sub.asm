.data 
	number1: .word 20
	number2: .word 12
.text
	lw $s0, number1		# s0 = number1 = 20
	lw $s1, number2 	# s1 = number2 = 12
	
	sub $t0, $s0, $s1 	# t0 = 20 - 12
	
	li $v0, 1
	move $a0, $t0		# move o valor de t0 para a0
	syscall