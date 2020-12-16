.data 
	msg: .asciiz "Digite seu peso: "
	zeroAsFloat: .float 0.0
.text

	lwc1 $f2, zeroAsFloat	# f0 = 0.0 para realizar operacoes
	
	li $v0,4
	la $a0, msg
	syscall
	
	# Ler float
	li $v0, 6
	syscall

	# Printar float
	li $v0, 2
	add.s $f12, $f0, $f2
	syscall
	
	li $v0, 10
	syscall