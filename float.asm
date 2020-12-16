.data
	pi: .float 3.14
.text 
	li $v0, 2       # printar float
	lwc1 $f12, pi	# armazenar pi em f12
	syscall