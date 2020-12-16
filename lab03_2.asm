.data
        Table: .space 20
        msg1: .asciiz "Digite um numero: "    
        msg3: .asciiz "\nOrdenado: "

.text	
.globl main		
		
main:                                               # inicio do programa principal
        addi $s0, $zero, 4                          # ajustar a pilha
        addi $t0, $zero, 0                          # armazenar 0 em t0
		
inicio:

        li $v0, 4                                   # syscall para string
        la $a0, msg1                                # chamar msg1                  
        syscall

        li $v0, 5				                    # syscall para ler numeros inteiros
        syscall			                            
		
        add $t1, $t0, $zero                         # soma de t0 + 0
        sll $t1, $t0, 2                             # shift para esquerda
        add $t3, $v0, $zero                         # soma de v0 + 0
        sw $t3, Table ( $t1 )                       
        addi $t0, $t0, 1                            # armazenar 1 em t0
        slt $t1, $s0, $t0                           # seta $t1 se $s0 for menor que $t0
        beq $t1, $zero, inicio                      # se $t1 for zero volta para o inicio

        la $a0, Table
        addi $a1, $s0, 1                            

        jal bubbleSort

        li $v0, 4                                   # syscall para string
        la $a0, msg3                                # chamar msg3
        syscall
        
        la $t0, Table
        add $t1, $zero, $zero

printar:

        lw $a0, 0($t0)                              # Parametro (inteiro a ser escrito)
        li $v0, 1                                   # syscall para escrever inteiros
        syscall

        addi $t0, $t0, 4                            
        addi $t1, $t1, 1
        slt $t2, $s0, $t1
        beq $t2, $zero, printar
        li $v0, 10
        syscall

bubbleSort:

        add $t0, $zero, $zero                       # seta $t0 = 0

loop:

        addi $t0, $t0, 1                            # acresenta 1 em $t0
        bgt $t0, $a1, Fimloop                       # se  t0 for menor que a1 vai para Fimloop para dar break;
        add $t1, $a1, $zero 
        
aux:

        bge $t0, $t1, loop                          # se $t1 for menor ou igual a $t0 volta para loop
        addi $t1, $t1, -1                           # decrescenta 1 em $t1
        mul $t4, $t1, 4                             # table[$t1]
        addi $t3, $t4, -4                           #table[$t1 - 1]
        add $t7, $t4, $a0                           #table[$t1]
        add $t8, $t3, $a0                           #table[$t1 - 1]
        lw $t5, 0($t7)
        lw $t6, 0($t8)
        bgt $t5, $t6, aux
        sw $t5, 0($t8)
        sw $t6, 0($t7)
        j aux                                   # retorna para aux ate ter 5 posicoes no vetor

Fimloop:

        jr $ra