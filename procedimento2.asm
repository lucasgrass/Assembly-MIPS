.data
	
.text

main:
	addi $a0, $zero, 50
	addi $a1, $zero, 100
	
	jal addNumbers
	
	li $v0, 1
	addi $a0, $v1, 0
	syscall
	
	li $v0, 10	# Codigo para finalizar o programa
	syscall
	
addNumbers:
	
	add $v1, $a0, $a1
	
	jr $ra		# Voltar para o procedimento que chamou esse