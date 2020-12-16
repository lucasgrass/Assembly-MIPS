.data
	msg: .asciiz " "
.text
	addi $t0, $zero, 10
	addi $t1, $zero, 3
	
	div $t0, $t1		# Quociente em lo e o resto em hi
	
	mflo $s0
	mfhi $s1
	
	li $v0, 1
	add $a0, $zero, $s0
	syscall
	
	li $v0, 4
	la $a0, msg
	syscall
	
	li $v0, 1
	add $a0, $zero, $s1
	syscall
	
