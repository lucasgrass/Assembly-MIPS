.data 
	msg: .word 14
	
.text
	li $v0, 1	
	lw $a0, msg
	syscall