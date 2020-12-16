.data
	msg: .asciiz "Hi, everybody, \nMy name is Lucas.\n"
.text

main:
	jal PrintarMsg
	
	li $v0, 10	# Codigo para finalizar o programa
	syscall
	
PrintarMsg:
	
	li $v0, 4
	la $a0, msg
	syscall
	
	jr $ra		# Voltar para o procedimento que chamou esse
		