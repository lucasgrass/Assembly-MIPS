.data 
	msg: .asciiz "Hello, "
	userInput: .space 20	# 20 caracteres
.text

main:
	# Ler texto
	li, $v0, 8
	la $a0, userInput	# Dizer onde vai ser armazenado
	li $a1, 20		# Dizer o maximo do texto
	syscall
	
	# Ler msg
	li $v0, 4
	la $a0, msg
	syscall
	
	# Mostrar texto digitado
	li $v0, 4
	la $a0, userInput
	syscall
	
	li $v0, 10
	syscall