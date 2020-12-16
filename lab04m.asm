.data
	matrizX: .float 0, 0, 0, 0, #Matriz de precis�o simples
		       0, 0, 0, 0,
		       0, 0, 0, 0,
		       0, 0, 0, 0

	matrizY: .float 0, 0, 0, 0, #Matriz de precis�o simples
		       0, 0, 0, 0,
		       0, 0, 0, 0,
		       0, 0, 0, 0

	matrizZ: .float 0, 0, 0, 0, #Matriz de precis�o simples
		       0, 0, 0, 0,
		       0, 0, 0, 0,
		       0, 0, 0, 0


	msg1: .asciiz "Entre com o numero do vetor :"
	msg2: .asciiz "Entre com o numero do vetor Y:"
	space: .asciiz " "
	nextline: .asciiz "\n"
	msg3: .asciiz "\n presione [ENTER] para continuar"
	buffer: .space 100
.text 
.globl main


main:


	la $a1,matrizX 					#carrega o endere�o de matrizX em a1
	jal LeMatriz 					#chama fun��o le matriz
	
	li $v0,4 						#chamada para printar string
	la $a0,msg3 					#passagem da string a se printada
	syscall
	
	li $v0,8 						#chamada para ler string
	la $a0,buffer 					#armazenando string no buffer 
	li $a1,100 						#passagem do tamanho
	syscall
	
	li $v0,4 						#chamada para printar strings
	la $a0,nextline 				#passagem do parametro a ser escrito
	syscall

	la $a1,matrizY					#carrega endere�o da matrizY em a1
	jal LeMatriz 					#chama a fun��o l� matriz


	la $a1,matrizX 					#carrega endere�o da matrizX em a1
	la $a2,matrizY 					#carrega endere�o da matrizY em a2
	la $a3,matrizZ 					#carrega endere�o da matrizZ em a3
	jal SomaMatriz 					#chama a fun��o que soma as matriz/ z[i][j] = x[i][j] + y[i][j] 

	la $a1,matrizZ 					#carrega endere�o da matrizZ em a1
	jal imprimirMatriz				#chama a fun��o que imprimi a matriz

	li $v0,10 						#return 0, impede acumulo de lixo na mem�ria
	syscall

LeMatriz:
	move $s0,$zero 					# indice I, inicia em 0/ i = 0;
inicio:
	move $s1,$zero 					# Indice J, inicia em 0/ j = 0;

LeDenovo:
									#endere�amento da matriz
	sll $t4,$s0,2 					#i*4
	add $t4,$t4,$s1 				#i*4+j
	
	sll $t4,$t4,2 					#(i*4+j)*4
	add $t5,$t4,$a1					#passagem do endere�o + posi��o da matriz

	li $v0,4 						#chamada para imprimir string
	la $a0,msg1 					#passagem da string a ser escrita
	syscall 

	li $v0,6 						#chamada para armazernar float, numero armazenado fica em $f0
	syscall

	swc1 $f0,($t5) 					#salva numero de $f0 na matriz na posi��o [i][j]

	

	addi $s1,$s1,1 					#j++

	bne $s1,4, LeDenovo 			#verifica se j != 4 pula pra LeDenovo 

	addi $s0,$s0,1 					#i++
	bne $s0,4,inicio 				#verifica, caso i != 4 pula para inicio

	jr $ra 							# return


SomaMatriz: 						#fun��o de soma da matriz
	move $s0,$zero 					#inicia i = 0;
inicio2:
	move $s1,$zero 					#inicia j = 0

soma:

	sll $t4,$s0,2 					#i*4
	add $t4,$t4,$s1 				#i+j

	sll $t4,$t4,2 					#(i*4+j)*4
	add $t5,$t4,$a1 				#passagem do endere�o e da posi��o da matriz
	add $t6,$t4,$a2 				#passagem do endere�o e da posi��o da matriz
	add $t7,$t4,$a3 				#passagem do endere�o e da posi��o da matriz

	lwc1 $f2,($t5) 					#carrega valor de m[i][j] no registrador $f2
	lwc1 $f3,($t6) 					#carrega valor de m[i][j] no registrador $f3

	add.s $f2,$f2,$f3 				#$f2 recebe a soma de $f2 e $f3/ $f2 = $f2 + $f2;

	swc1 $f2,($t7) 					#carrega o valor da soma na matrizZ

	addi $s1,$s1,1 					#j++
	bne $s1,4, soma 				#verifica se j != 4, pula para soma



	addi $s0,$s0,1 					#i++
	bne $s0,4,inicio2 				#verifica, caso i != 4, pula para inicio2

	jr $ra 							# return

imprimirMatriz: 
	move $s0,$zero 					#inicia i com 0, i = 0;
inicio3:
	move $s1,$zero 					#inicia j com 0, j = 0;

impressao:
	sll $t4,$s0,2 					#i*4
	add $t4,$t4,$s1 				#i*4+j
	
	sll $t4,$t4,2 					#(i*4+j)*4
	add $t5,$t4,$a1					#passa endere�o + posi��o da matriz

	li $v0,2 						#chama para imprimir float
	lwc1 $f12,($t5) 				#passagem do numero a ser printado
	syscall

	li $v0,4 						#chamada para imprimir strings
	la $a0,space 					#passagem da string a ser imprimida 
	syscall

	sub $a1,$a1,$s3 				#retorna o endere�o inicial para a matriz

	addi $s1,$s1,1 					#j++
	bne $s1,4, impressao 			#verifica se j != 4, pula para impressao 


	li $v0,4 						#chamada para imprimir strings
	la $a0,nextline 				#passagem da string a ser escrita
	syscall

	addi $s0,$s0,1 					#i++
	bne $s0,4,inicio3 				#verifica, caso i != 4, pula para inicio3

	jr $ra 							# return
