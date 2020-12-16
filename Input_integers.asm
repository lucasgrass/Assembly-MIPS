-.data
	msg: .asciiz "Digite sua idade: "
	msg1: .asciiz "\nYour age is "
.text

	li $v0, 4
	la $a0, msg
	syscall
	
	# Get the user's age
	li $v0, 5
	syscall
	
	# Salvar em t0
	move $t0,$v0
	
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $v0, 1
	add $a0, $zero, $t0
	syscall
	
	li $v0, 10
	syscall
	
	
