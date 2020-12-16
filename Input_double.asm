.data
	msg: .asciiz "Entre com o valor de e: "
.text

	li $v0, 4
	la $a0, msg
	syscall
	
	# Ler double
	li $v0, 7
	syscall
	
	# Printar double
	li $v0, 3
	add.d $f12, $f0, $f2
	syscall
	
	li $v0, 10
	syscall
	