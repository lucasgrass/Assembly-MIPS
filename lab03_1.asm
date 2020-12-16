.data

msg1: .asciiz "\nDigite um numero para calcular o fatorial: "

.text                
.globl main               

main:                 # inicio do programa principal

	addi $sp,$sp, -4      # ajusta a pilha 
	sw $ra, 0($sp)        # salva o endereço de retorno

	li $v0, 4             # syscall para string
	la $a0, msg1          # chamar msg1
	syscall               

	li $v0, 5             # syscall para ler numeros inteiros
	syscall               
	add $a1, $v0, $zero   # Armazena em a1 o número


	jal fatorial          # chama o procedimento fatorial

	li $v0, 1             # syscall para escrever inteiros
	add $a0, $zero, $v1   # escever numero inteiro 
	syscall               

	li $v0, 5             # syscall para ler numeros inteiros
	syscall               

	lw $ra,0($sp)         # carrega o registrador ra da pilha
	addi $sp,$sp, 4       # ajusta a pilha 

	jr $ra                # fim do programa

L1: 

	addi $a1, $a1, -1     # decrementa N
	jal  fatorial    	  # chamada para a recursão
	lw   $a1, 0($sp)      # volta o N original
	lw   $ra, 4($sp)      # retorna o endereco 
	addi $sp, $sp, 8      # retira 2 numeros da pilha 

	mul  $v1, $a1, $v1    # retorna N*fatorial(N-1)

	jr   $ra              # fim do procedimento

fatorial:

	addi $sp, $sp, -8     # ajusta a pilha para dois numeros
	sw   $ra, 4($sp)      # salva o endereco de retorno
	sw   $a1, 0($sp)      # salva o valor

	slti $t0, $a1, 1      # testa para N < 1
	beq  $t0, $zero, L1   

	addi $v1, $zero, 1    # se N for menor que 1 o resultado é 1
	addi $sp, $sp, 8      # retira dois numeros da pilha 
	jr   $ra              # fim do procedimento