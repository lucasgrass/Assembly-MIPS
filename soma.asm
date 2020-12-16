.data
	number1: .word 5
	number2: .word 3
.text
	lw $t0, number1
	lw $t1, number2	
	
	add $t2, $t1, $t0  # t2 = t1 + t0
	
	li $v0, 1
	add $a0, $t2, $zero
	syscall
	