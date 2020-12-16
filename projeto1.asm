.data
	#----------------DATA DAS VARIAVEIS UTILIZADAS----------------------------------------------------------------
	qtdDeAlunos:		.word 5
	alunosCadastrados:	.word 0
	raAlunos:		.word 0, 0, 0, 0, 0
	mediaAlunos:		.float 0, 0, 0, 0, 0
	qtdDeProjetos:		.word 2
	pesoProjeto:		.float 5
	qtdDeAtividades:	.word 5
	pesoAtividade:		.float 2
	vinte:			.float 20
	# notas vatriz[alunos][qtdDeAtividades+qtdDeProjetos], neste caso m[5][7]
	notas: 			.float  0, 0, 0, 0, 0, 0, 0, 
					0, 0, 0, 0, 0, 0, 0, 
					0, 0, 0, 0, 0, 0, 0, 
					0, 0, 0, 0, 0, 0, 0, 
					0, 0, 0, 0, 0, 0, 0 # (i*7 + j)*4 + endereco inicial
	umQuarto: 	.float 0.25
	tresQuartos:	.float 0.75
	dez:		.float 10
	zero:		.float 0
	#----------------DATA DAS MENSAGENS UTILIZADAS----------------------------------------------------------------
	nomeProjeto:		.asciiz "\t\tRA: X  P1   P2   "
	nomeAtividade:		.asciiz "A1   A2   A3   A4   A5"
	pulaLinha:	.asciiz "\n\t"
	espaco:		.asciiz "  "
	RaNCad:		.asciiz "\n\t\tRa inexistente\n"
	RaCadastrado:	.asciiz "\n\t\tRa ja cadastrado\n"
	RaInvalido:	.asciiz "\n\t\tRa invalido\n"
	MenuPart1:	.asciiz "\n\t\t[1] Cadastrar RA Aluno\n\t\t[2] Alterar Nota\n\t\t[3] Exibir notas e medias dos alunos\n"
	MenuPart2:	.asciiz "\t\t[4] Medias aritmetica das medias dos alunos\n\t\t[5] Relacao dos aprovados na materia\n\t\t[0] Sair\n\t\t -> "
	invalid:	.asciiz "\n\t\tEntrada Invalida\n\t\t -> "
	semAlunos:	.asciiz "\n\t\tOpcao invalida, nao ha alunos cadastrados\n"
	limiteAlunos:	.asciiz "\n\t\tOpcao invalida, ja exitem 5 alunos cadastrados\n"
	DigiteRA:	.asciiz "\n\t\tDigite o RA\n\t\t -> "
	MudarNota:	.asciiz "\n\t\t[1] Adicionar ou Alterar Nota\n\t\t[2] Remover Nota\n\t\t[0] Voltar\n\t\t -> "
	aprovado:	.asciiz " Aprovado"
	reprovado:	.asciiz " Reprovado"
	AtivProj:	.asciiz "\n\t\t[1] Alterar Nota Projeto\n\t\t[2] Alterar Nota Atividade\n\t\t -> "
	QualAtiv:	.asciiz "\n\t\tQual atividade 1 ate 5?\n\t\t -> "
	QualProj:	.asciiz "\n\t\tQual projeto 1 ou 2?\n\t\t -> "
	DigiteNota:	.asciiz "\n\t\tDigite a nota\n\t\t -> "
	mostraRa:	.asciiz "\n\t\tRA: "
	mostraMedia:	.asciiz "  Media: "
	mediaAritimetica:	.asciiz "\n\t\tMedia Aritmetica das medias dos alunos: "
	mediaAritimeticaArredondada: .asciiz "\n\t\tMedia Aritmetica arredondada: "
					
#Estrutura da MATRIZ
#			 P1 P2 A1 A2 A3 A4 A5
#Aluno 1	 0, 0, 0, 0, 0, 0, 0, 
#Aluno 2	 0, 0, 0, 0, 0, 0, 0, 
#Aluno 3	 0, 0, 0, 0, 0, 0, 0, 
#Aluno 4	 0, 0, 0, 0, 0, 0, 0, 
#Aluno 5	 0, 0, 0, 0, 0, 0, 0, 
#
#P = Projeto	A = Atividade		

.text	
.globl main 
main:
#----------------INICIO DO CODIGO----------------------------------------------------------------
	# inicializacao de variaveis
	li $s0, 0			# index i = 0
	li $s1, 0			# index j = 0
	lw $s2, qtdDeAlunos		# I max da matrix nota
	lw $s3, qtdDeAtividades		# qtdDeAtividades
	lw $s4, qtdDeProjetos		# qtdDeProjetos
	add $s5, $s3, $s4		# qtdDeProjetos+qtdDeAtividades = J max da matrix nota
	lw $s6, alunosCadastrados
	li $s7, 1				#flg para realizar calculo de media
		
	la $a1, notas			# carrega o endereco de notas em a1
	la $a2, raAlunos		# carrega o enderco de raAlunos em a2
	la $a3, mediaAlunos		# carrega o enderco de mediaAlunos em a3
	
	l.s $f10, zero			#f10 = qtd alunos em float	
	l.s $f1, umQuarto
	l.s $f2, tresQuartos
	add.s $f11, $f1, $f2		# f11 = 1
	
	# nao carreg x em a0, pois usamos a0 para print de mensagens
	j Menu #----------------JUMP PARA MENU APOS INICIALIZAR AS VARIAVEIS----------------------------------------------------------------
	
	
#----------------ENTRADA 1 DO MENU CADASTRO DE RA------------------------------------------------
CadastrarRa:
	beq $s6, $s2, limiteDeAlunoExedido	# Verificar se o limite de alunos foi excedido
	
cadastraDnv:
	li $v0, 4				# Exibir texto	
	la $a0, DigiteRA
	syscall
	
	li $v0, 5				# Entrada do usuario
	syscall
	
	move $t0, $v0
	
	bgt $t0, 0, RaValido
	
	li $v0, 4
	la $a0, RaInvalido
	syscall
	
	j cadastraDnv
	
RaValido:
	li $t0, 0				# t0 = 0
	move $t2, $v0				# t2 = entrada do usuario
	
	#verificacao para n cadastrar ra repetidp
 loop:
 	beq $t0, $s6, cadastra			# Se s6 = t0 pula para cadastra, pois n ha ra's repitidos
	move $t1, $t0				# t1 = t0
	mul $t1, $t1, 4				# multiplica t1 por 4 para achar a posicao vetorial
	add $t1, $t1, $a2			# t1 = posicao vetorial + endereco
	lw $t1, ($t1)				# Load na pos t1 em t1
	addi $t0, $t0, 1			# +1 em t1
	bne $t1, $t2 loop			# Se t1 != t2 pula para loop
	
	li $v0, 4				# Exibir texto
	la $a0, RaCadastrado
	syscall
	
	j cadastraDnv 				#Le outro ra em caso de repeticao
	
cadastra:
	move $t0, $a2				# t0 = endereco do vetor ra alunos
	move $t1, $s6				# t1 = qtd de alunos cadastrados
	mul $t1, $t1, 4				# t1*4 = posicao vetorial
	add $t0, $t1, $t0			# t0 = posicao vetorial + endereco
	sw $v0, ($t0)
	
	li $s7, 1				#calculo de media = 1
	
	addi $s6, $s6, 1			# s6++
	add.s $f10, $f10, $f11			# f10++
	
	addi $t5, $zero, 0			# t5 = 0	
#----------------Bubble Sort (ordenacao na insercao)------------------------------------------------
bubble:
	#inicializa enderecos e contadores
	addi $t4, $zero, 1			
	move $t0, $a2				
	addi $t0, $t0, -4			
	
LoopInterno:
	beq $t4, $s6, fimLoopInterno		# Se t4 = qtd de alunos cadastrados, realizou um laco de bubble entao pula para fimLoopInterno
	
	addi $t0, $t0, 4			# anda em uma pos no vetor
	addi $t1, $t0, 4			# t1 = t0 + 4, uma pos a frente de t0

	lw $t2, ($t0)				# Load pos t0 para t2
	lw $t3, ($t1)				# Load pos t1 para t3
	
	addi $t4, $t4, 1			# t4++
	ble  $t2, $t3, LoopInterno	# Se t2 < t3 pula para LoopInterno
	
	#swap de posicao
	sw $t2, ($t1)		
	sw $t3, ($t0)				
	
	#inicializa variaveis para vazer um swap entre as linhas da matriz, pois o vetor esta diretamente ligado a ordem das linhas
	addi $t6, $t4, -2			#i da linha referente a pos t1 no vetor
	addi $t7, $t4, -1			#i da linha referente a pos t2 no vetor
	mul $t6, $t6, 28 			# multiplica t6 por 28, i*28 = i*7*4, pois cada linha tem 7 elementos de 4 bits cada
	mul $t7, $t7, 28 			# multiplica t7 por 28		
	add $t6, $t6, $a1 			#t6 = i*28 = pos vetorial, pois j = 0 para a primeira coluna
	add $t7, $t7, $a1			#t6 = i*28 = pos vetorial, pois j = 0 para a primeira coluna
	move $t8, $zero				#inicializa contador
	
swapLinha:													#inicio do loop de swap de linha
	l.s $f0, ($t6)				# Load t6 em f0				
	l.s $f1, ($t7)				# Load t7 em f1
	s.s $f0, ($t7)				#swapa os valores
	s.s $f1, ($t6)				
	addi $t6, $t6, 4 			# t6+4 = prox elemento
	addi $t7, $t7, 4			# t7+4 = prox elemento
	addi $t8, $t8, 1			# t8++
	bne $t8, 7, swapLinha			# Se t8 != 7 continua a rotina de swap
	j LoopInterno				#reinicia o loop interno
	
fimLoopInterno:
	addi $t5, $t5, 1			#t5++
	bne $t5, $s6, bubble		#verifica se terminou o bubble se nao continua
	
	j Menu						#jump menu
	
#----------------FIM DA ENTRADA 1------------------------------------------------

opcaoInvalida:				#Em caso de opcao invalida na entrada 2 print mensagem e volta no inicio da entrada 2
	li $v0, 4				# Exibir texto
	la $a0, invalid
	syscall
	j AlterarNota
	
RaNcadastrado:				#Em caso de opcao invalida na entrada 2 print mensagem e volta no inicio da entrada 2
	li $v0, 4				# Exibir texto
	la $a0, RaNCad
	syscall


#----------------ENTRADA 2 DO MENU------------------------------------------------
AlterarNota:	
	li $v0, 4				# Exibir texto
	la $a0, MudarNota
	syscall
	
invalido:
	li $v0, 5
	syscall
	
	beq $v0, 1, AdicionarNota		# Se a v0 for = 2 pula para AdicionarNota
	beq $v0, 2, ExcluirNota			# Se a v0 for = 1 pula para ExcluirNota
	beqz $v0, Menu
	
	li $v0, 4				# Exibir texto
	la $a0, invalid
	syscall
	
	j invalido

ExcluirNota:
	li $v0, 4				# Exibir texto	
	la $a0, DigiteRA
	syscall
	
	li $v0, 5				# entrada de int, salva-o em v0
	syscall
	
	li $t0, 0				#inicia contador
	move $t2, $v0			#move a entrada para t2

#Loop para verificar se o Ra existe dentre os cadastrados
 loopVerifica:
 	beq $t0, $s6, RaNcadastrado		#verifica se ja o loop ja rodou a mesma qtd de vezes q a qtd de alunos cadastrados, se sim o ra n esta cadastrado
	move $t1, $t0					#move o contador para para t1
	mul $t1, $t1, 4					#multiplica ele por 4 para chegar na posicao
	add $t1, $t1, $a2				#t1 = pos vetorial + endereco
	lw $t1, ($t1)					#carrega em t1 o RA daquela posicao
	add $t0, $t0, 1					#contador++
	bne $t1, $t2, loopVerifica		#verifica se o ra lido e igula a entrada	
	
	addi $s0, $t0, -1			# passa o valor de i relativo ao RA do aluno
	
	li $v0,4				# Exibir texto	
	la $a0, AtivProj
	syscall
	
	li $v0, 5				# Leitura de int 
	syscall
	
	move $t0, $v0			#move o int lido para t0
	 
	beq $t0, 1, ExcluirProjeto		#menu de t0, 1 vai para excluir projeto, 2 exclui atividade, se nao volta para o menu de alterar atividade com mensagem de invalido  
	beq $t0, 2, ExcluirAtividade

ExcluirProjeto:						#inicio de excusao de projeto
	li $v0,4				# Exibir texto	
	la $a0, QualProj
	syscall

	li $v0, 5				# Leitura de int 
	syscall
	
	beq $v0, 1, removeNota	#menu de v0, 1 vai para excluir projeto, 2 exclui projeto, se nao volta para o menu de alterar atividade com mensagem de invalido 
	beq $v0, 2, removeNota	#menu de v0, 1 vai para excluir projeto 1, 2 exclui projeto 2, se nao volta para o menu de alterar atividade com mensagem de invalido  
	j opcaoInvalida
	
removeNota:
#remove a nota, seta aquela nota com 0
	move $t2, $v0			#valor lido para t2
	
	addi $s1, $t2, -1			#Valor de j
	
	mul $t0, $s0, $s5			# i * (qtdProjeto+qtdAtividade) = i*7 e armazena em t0
	add $t0, $t0, $s1			# 7*i + j = posicao vetorial
	mul $t0, $t0, 4				# multiplica por 4 a posicao
	add $t0, $a1, $t0			# endereco = 4*pos + endereco inicial
	
	l.s $f0, zero				# f0 = 0
	s.s $f0, ($t0)				# salva 0 na pos do projeto a excluir
	
	li $s7, 1					#como houve auteracao na nota seta flag para calculo de media = 1
	
	j Menu						#volta para o menu
	
ExcluirAtividade:				#excluir atividade
	li $v0,4				# Exibir texto	
	la $a0, QualAtiv
	syscall

	li $v0, 5				# Leitura de int
	syscall
	
	#verifica a entrada se e de 1 a 5
	blt $v0, 1, opcaoInvalida
	bgt $v0, 5, opcaoInvalida
	
	# Exibir texto calculo da posicao na memoria	
	addi $s1, $t2, 1			# Valor de j
	
	mul $t0, $s0, $s5			# i * (qtdProjeto+qtdAtividade) = i*7 e armazena em t0
	add $t0, $t0, $s1			# 7*i + j = posicao vetorial
	mul $t0, $t0, 4				# multiplica por 4 a posicao
	add $t0, $a1, $t0			# endereco = 4*pos + endereco inicial
	
	l.s $f0, zero				# load em f0 zero
	s.s $f0, ($t0)				#salva zero na posicao
	
	li $s7, 1					#como houve auteracao na nota seta flag para calculo de media = 1
	
	j Menu						#volta para o menu
	
AdicionarNota:
	li $v0, 4				# Exibir texto	
	la $a0, DigiteRA
	syscall
	
	li $v0, 5				#le int
	syscall
	
	li $t0, 0				#inicia contador
	move $t2, $v0			#move para t2 o valor lid0
	
 loopVerificaa:	#verifica se o ra esta cadastrado ou n
 	beq $t0, $s6, RaNcadastrado		#verifica se ja o loop ja rodou a mesma qtd de vezes q a qtd de alunos cadastrados, se sim o ra n esta cadastrado
	move $t1, $t0					#move o contador para para t1
	mul $t1, $t1, 4					#multiplica ele por 4 para chegar na posicao
	add $t1, $t1, $a2				#t1 = pos vetorial + endereco
	lw $t1, ($t1)					#carrega em t1 o RA daquela posicao
	add $t0, $t0, 1					#contador++
	bne $t1, $t2, loopVerificaa		#verifica se o ra lido e igula a entrada	
	
	addi $s0, $t0, -1			# passa o valor de i relativo ao RA do aluno
	
	
	li $v0,4					#print mensagem
	la $a0, AtivProj
	syscall
	
	li $v0, 5					#le int
	syscall
	
	move $t0, $v0				#valor lido para t0
	
	#mini menu para se deve mudar projeto ou atividade
	beq $t0, 1, MudarProjeto		
	beq $t0, 2, MudarAtividade
	j opcaoInvalida				#pula para invalido
	
MudarProjeto:
	li $v0,4					#print mensagem
	la $a0, QualProj
	syscall

	li $v0, 5					#le int
	syscall
	#se bor um ou 2 le a nota, senao invalido
	beq $v0, 1, leNota
	beq $v0, 2, leNota
	j opcaoInvalida
	
leNota:							#ler nota
	move $t2, $v0
	
leia:	
	li $v0, 4					# Exibir texto
	la $a0, DigiteNota
	syscall

	li $v0, 6					# le float
	syscall  
	
	l.s $f1, zero				#se o valor lido estiver entre 0 e 10 ele le, senao pede para digitar a nota novamente
	c.lt.s $f0,$f1
	bc1t leia
	l.s $f1, dez
	c.le.s $f0, $f1
	bc1f leia
	
	addi $s1, $t2, -1			#Valor de j
	
	mul $t0, $s0, $s5			# i * (qtdProjeto+qtdAtividade) = i*7 e armazena em t0
	add $t0, $t0, $s1			# 7*i + j = posicao vetorial
	mul $t0, $t0, 4				# multiplica por 4 a posicao
	add $t0, $a1, $t0			# endereco = 4*pos + endereco inicial
	
	s.s $f0, ($t0)				#salva nota na memoria
	
	li $s7, 1					#flag para calculo de media = 1
	
	j Menu						#jump p/ o menu
	
MudarAtividade:					#mudar nota de atividade
	li $v0,4					#print de mensagem
	la $a0, QualAtiv
	syscall

	li $v0, 5					#le um numero
	syscall
	
	#verifica se a entrada esta entre 1 e 5, se nao pula para opcao invalida
	blt $v0, 1, opcaoInvalida
	bgt $v0, 5, opcaoInvalida

	
	move $t2, $v0				#valor lio para t2

voltaa:
	li $v0, 4					# Exibir texto
	la $a0, DigiteNota
	syscall

	li $v0, 6					# le um float 
	syscall  
	
	l.s $f1, zero				#se o valor lido estiver entre 0 e 10 ele le, senao pede para digitar a nota novamente
	c.lt.s $f0,$f1
	bc1t voltaa
	l.s $f1, dez
	c.le.s $f0, $f1
	bc1f voltaa
	
	addi $s1, $t2, 1			# Valor de j 
	
	mul $t0, $s0, $s5			# i * (qtdProjeto+qtdAtividade) = i*7 e armazena em t0
	add $t0, $t0, $s1			# 7*i + j = posicao vetorial
	mul $t0, $t0, 4				# multiplica por 4 a posicao
	add $t0, $a1, $t0			# endereco = 4*pos + endereco inicial
	
	s.s $f0, ($t0)				#salva na posicao
	
	li $s7, 1					#flag para calculo de media = 1
	
	j Menu						#jump menu
#----------------FIM DA ENTRADA 2 DO MENU------------------------------------------------
	
#----------------ENTRADA 3 DO MENU------------------------------------------------
ExibirMediasNotas:
	li $v0, 4				# Exibir texto
	la $a0, nomeProjeto
	syscall
	
	li $v0, 4				# Exibir texto
	la $a0, nomeAtividade
	syscall

	li $v0, 4				# Exibir texto
	la $a0, mostraRa
	syscall
	
	move $t2, $a2			#move endereco para t2
	lw $a0, ($t2)			#load ra
	
	li $v0, 1				#print ra
	syscall
	
	li $v0, 4				# Exibir texto
	la $a0, espaco
	syscall
	
forPrint:
	mul $t0, $s0, $s5			# i * (qtdProjeto+qtdAtividade) = i*7 e armazena em t0
	add $t0, $t0, $s1			# 7*i + j = posicao vetorial
	mul $t0, $t0, 4				# multiplica por 4 a posicao
	add $t0, $a1, $t0			# endereco = 4*pos + endereco inicial
	
	l.s $f12, ($t0)				#printa valor na pos da matriz
	li $v0, 2
	syscall
	
	addi $s1, $s1, 1			# j++; 
	
	li $v0, 4					# Exibir texto
	la $a0, espaco
	syscall
	
	bne $s1, $s5, forPrint		#enquato j n for = qtdAtividade+qtdDeProjetos, continua no loop de print
	li $s1, 0					# j=0
	
	addi $s0, $s0, 1			# i++;
	
	beq $s0, $s6, exibeMedias	#enquato j n for = qtdAlunosCadastrados, continua no loop de print
	
	li $v0, 4				# Exibir texto
	la $a0, mostraRa
	syscall	
	
	addi $t2, $t2, 4		#t2+=4 -> proximo endereco
	lw $a0, ($t2)			#salva em a0 o ra
	
	li $v0, 1				#print ra
	syscall
	
	li $v0, 4				# Exibir texto
	la $a0, espaco
	syscall
	
	bne $s0, $s6, forPrint	#enquato j n for = qtdAlunosCadastrados, continua no loop de print

exibeMedias:	# exibir medias
	#inicializa variaveis, contadores e enderecos
	move $t0, $s6			
	li $t1, 1
	move $t2, $a2
	move $t3, $a3
	
	li $v0, 4				# Exibir texto
	la $a0, mostraRa
	syscall
	
for:
	lw $a0, ($t2)		#printa o ra
	
	li $v0, 1
	syscall
	
	li $v0, 4				# Exibir texto
	la $a0, mostraMedia
	syscall
	
	l.s $f12, ($t3)			#printa media
	
	li $v0, 2
	syscall
	
	beq $t0, $t1, Saifor	#verifica se o ja printou todas as medias, se n continua no for
	
	li $v0, 4				# Exibir texto
	la $a0, mostraRa
	syscall
	#add 1 nos contadore e 4 nos enderecos
	addi $t1, $t1, 1
	addi $t2, $t2, 4
	addi $t3, $t3, 4

	j for					#jump para for
	
Saifor:
	li $v0, 4				# Exibir texto
	la $a0, pulaLinha
	syscall
	
	j Menu					#jump menu
	
#----------------FIM DA ENTRADA 3 DO MENU----------------------------------------------------------------
#----------------ENTRADA 4 DO MENU----------------------------------------------------------------
Aritmetica:
	#inicializa contadores e enderecos
	li $t0, 0
	move $t2, $a3 
	l.s $f0, zero
	
loopMediaAritimetica: 					#loop para calculo da media
	l.s $f1, ($t2)						#load do valor x
	add.s $f0, $f0, $f1					#somador+=x
	
	add $t2, $t2, 4						#vai para o proximo endereco
	addi $t0, $t0, 1					#add 1 no contador
	bne $t0, $s6, loopMediaAritimetica	#enquanto contador != de qtdAlunosCadastrados continua no loop

	div.s $f0, $f0, $f10				#s = s dividido pela qtdAlunosCadastrados
	
	li $v0, 4				# Exibir texto
	la $a0, mediaAritimetica
	syscall
	
	mov.s $f12, $f0						#print s
	li $v0, 2
	syscall
	
	#arredondamento
	cvt.w.s  $f1, $f0		#converte valor para int pra perder a parte do float
   	cvt.s.w $f1, $f1		#converte de volta para float
   	sub.s $f2, $f0, $f1 	#subtrai para pegar o decimal (float-inteiro)
   	
   	l.s $f3, umQuarto		#f3 = 0,25
   	l.s $f4, tresQuartos	#f4 = 0,75
   	
   	c.lt.s $f2, $f3			#compara se o float e menor q 0,25, se sim termina o arredondamento = parte inteira
   	bc1t arredondada
   	add.s $f1, $f1, $f3		#add 0,25 duas vezes
   	add.s $f1, $f1, $f3
   	c.lt.s $f2, $f4			#compara se o float e menor q 0,25, se sim termina o arredondamento = parte inteira + 0,5
   	bc1t arredondada
   	add.s $f1, $f1, $f3		#se n add 0,25 2 vezes, arredondamento = parte inteira + 1
   	add.s $f1, $f1, $f3
	#final do arredondamento
   	
arredondada:
	li $v0, 4				# Exibir texto
	la $a0, mediaAritimeticaArredondada
	syscall
	
	mov.s $f12, $f1			#print float arredondado
	li $v0, 2
	syscall
	
	li $v0, 4
	la $a0, pulaLinha
	syscall
	
	j Menu					#j para menu
#----------------FIM DA ENTRADA 4 DO MENU----------------------------------------------------------------
# ENTRADA 5 MENU-------------------------------------------------------------------------------------------------------------------------
AprovadosReprovados:
	#inicializa as contadore e enderecos
	li $t0, 0
	move $t1, $a2 
	move $t2, $a3
	#f0 = 5
	add.s $f0, $f11, $f11
	add.s $f0, $f0, $f0
	add.s $f0, $f0, $f11
	
loopAprovacao:
	li $v0, 4				# Exibir texto
	la $a0, mostraRa
	syscall

	lw $a0, ($t1)			#printa ra
	li $v0, 1
	syscall

	l.s $f1, ($t2)
	c.lt.s $f1, $f0			#se maior q 5 aprovado, se nao reprovado
	bc1t reprovados
	li $v0, 4				# Exibir texto
	la $a0, aprovado
	syscall
	j finaliza
	
reprovados:
	li $v0, 4				# Exibir texto
	la $a0, reprovado
	syscall
	
finaliza:
	#aad 4 aos enderecos e 1 ao contador
	add $t1, $t1, 4
	add $t2, $t2, 4
	addi $t0, $t0, 1
	bne $t0, $s6, loopAprovacao	#se contador = qtdAlunosCadastrados termina

	
	j Menu 					#pula para menu
#----------------FIM DA ENTRADA 5 DO MENU----------------------------------------------------------------

limiteDeAlunoExedido:
	li $v0, 4				# Exibir texto
	la $a0, limiteAlunos
	syscall

	j Menu 					#pula para menu
	
nTemAlunoCadastrado: 
	li $v0, 4				# Exibir texto
	la $a0, semAlunos
	syscall

Menu:	
	li $s0, 0				# set index i = 0
	li $s1, 0				# set index j = 0
	
	li $v0, 4				# Exibir texto
	la $a0, MenuPart1
	syscall
	
	li $v0, 4				# Exibir texto
	la $a0, MenuPart2
	syscall

LeNum:
	li $v0, 5				
	syscall
	
	move $t0, $v0				# Mover a entrada do usuario para t0
	
	beqz $t0, Fim				# Se t0 for = 0 pula para Fim
	blt $t0, 0, entradaInvalida		# Se a t0 for = 4 pula para Aritmetica
	bgt $t0, 5, entradaInvalida		# Se a t0 for = 5 pula para AprovadosReprovados	
	
	beq $t0, 1, CadastrarRa			# Se a t0 for = 1 pula para CadastrarRa	
	
	beqz $s6, nTemAlunoCadastrado		# Verificar se ha alunos cadastrados
	
	beq $t0, 2, AlterarNota 		# Se a t0 for = 2 pula para AlterarNota
	
	beqz $s7, nCalcula				#se a flag for 1 calcula ou recalcula a media, se nao n calcula
	
	l.s $f2, zero				# s = 0
	
calculoMedia:					#loop para calculo de media
	mul $t1, $s0, $s5			# i * (qtdProjeto+qtdAtividade) = i*7 e armazena em t0
	add $t1, $t1, $s1			# 7*i + j = posicao vetorial
	mul $t1, $t1, 4				# multiplica por 4 a posicao
	add $t1, $a1, $t1			# endereco = 4*pos + endereco inicial
	
	l.s $f0, ($t1)				#load do valo m[i][j]
	l.s $f1, pesoAtividade		#salva em f1 peso da atividade
	bgt $s1, 1, pula			#se por atividade continua normar, se n salva em f1 peso do projeto
	l.s $f1, pesoProjeto
	
pula:
	mul.s $f1, $f1, $f0			#multiplica pelo peso
	add.s $f2, $f2, $f1			#addiciona ao somador
	addi $s1, $s1, 1			# j++
	
	bne $s1, $s5, calculoMedia	#continua o calcula da somatoria se n chegou ao fim da linha
	li $s1, 0				# j = 0
	
	move $t2, $s0			#move par t2 o valor de i, que correspone a posicao vetorial do vetor media alunos
	mul $t2, $t2, 4			#mul i*4 para achar a posicao vetorial
	add $t2, $t2, $a3		#t2 = posicao vetorial+endereco inicial = endereco da posicao
	l.s $f1, vinte			#f1 = 20
	div.s $f0, $f2, $f1		#divide somatoria por 20, calculando a media
	
	cvt.w.s  $f1, $f0		#converte valor para int pra perder a parte do float
   	cvt.s.w $f1, $f1		#converte de volta para float
   	sub.s $f2, $f0, $f1 	#subtrai para pegar o decimal (float-inteiro)
   	
   	l.s $f3, umQuarto		#f3 = 0,25
   	l.s $f4, tresQuartos	#f4 = 0,75
   	
   	c.lt.s $f2, $f3			#compara se o float e menor q 0,25, se sim termina o arredondamento = parte inteira
   	bc1t salva
   	add.s $f1, $f1, $f3		#add 0,25 duas vezes
   	add.s $f1, $f1, $f3
   	c.lt.s $f2, $f4			#compara se o float e menor q 0,25, se sim termina o arredondamento = parte inteira + 0,5
   	bc1t salva
   	add.s $f1, $f1, $f3		#se n add 0,25 2 vezes, arredondamento = parte inteira + 1
   	add.s $f1, $f1, $f3
   	
salva:
	s.s $f1, ($t2)			#salva o valor arredondado no endereco
	l.s $f2, zero			#f2 = 0
	
	addi $s0, $s0, 1			# i++
	bne $s0, $s6, calculoMedia	
	
	li $s0, 0				# i = 0
	li $s1, 0				# j = 0
	
nCalcula:
	beq $t0, 3, ExibirMediasNotas		# Se a t0 for = 3 pula para ExibirMediasNotas
	beq $t0, 4, Aritmetica			# Se a t0 for = 4 pula para Aritmetica
	beq $t0, 5, AprovadosReprovados		# Se a t0 for = 5 pula para AprovadosReprovados	
	
entradaInvalida:	
	li $v0, 4				# Exibir texto
	la $a0, invalid
	syscall
	
	j LeNum					#j para ler numero 
	
Fim:
 	li $v0,10				#encerra o programa
 	syscall 	
