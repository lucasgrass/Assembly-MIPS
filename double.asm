.data 
	msg: .double 7.202
	zeroDouble: .double 0.0
.text
	ldc1 $f2, msg
	ldc1 $f0, zeroDouble
	
	li $v0, 3  	# printar a double
	add.d $f12, $f2, $f0 # adicionar 0 em 7.202 e guardar em f12
	syscall