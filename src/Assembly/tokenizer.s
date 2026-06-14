# ==============================================================================
# Função: tokenizer
# Descrição: Extrai tokens de uma string e contabiliza as frequências em uma Tabela Hash
#
# @param a0: Ponteiro para o endereço base da string.
# @param a1: Ponteiro para o endereço base de uma Tabela Hash vazia
# @param a2: Tamanho da HashTable
#
# @return a0: Ponteiro para o endereço base da Tabela Hash preenchida
# ==============================================================================

.data 
	a: .ascii "a"
	z: .ascii "z"

.text
.globl tokenizer

tokenizer:
	addi sp, sp, -32
    sw ra, 28(sp)
    sw t0, 24(sp)
    sw t1, 20(sp)
    sw t2, 16(sp)
	sw s3, 12(sp)
	sw t4, 8(sp)
    sw t5, 4(sp)
    sw t6, 0(sp)

    #Inicializa os dois ponteiros, e as letras 'a' e 'z' para comparação

	mv s3, a1 #s3 -> Endereço base da HashTable

	#s8 -> Maior endereço possível da HashTable
	slli s8, a2, 3
	add s8, s8, s3 

	mv t5, a0
	mv t6, a0
	
	la t1, a
	lb t1, 0(t1)
	
	la t2, z
	lb t2, 0(t2)
	
testa_caractere:
    #Carrega o caractere e caso não seja uma letra, chama o separador do token
	
	lb t0, 0(t6)
	
	blt t0, t1, separador_token
	bgt t0, t2, separador_token

	addi t6, t6, 1
	j testa_caractere
	
separador_token:
    #Caso não seja letra, checa se os ponteiros são diferentes para salvar o token
	
	beq t5, t6, atualiza_ponteiro_tokenizer

    sub t4, t6, t5

	#Chama Hashfunc, t3 -> Hash do Token
	addi sp, sp, -8
    sw a1, 4(sp)
    sw a0, 0(sp)

	mv a0, t5
	mv a1, t4
	jal hashfunc

	mv t3, a0

	lw a1, 4(sp)
	lw a0, 0(sp)
	addi sp, sp, 8

	#S4 conterá o endereço do ponteiro na HashTable, s4+4 conterá a frequência
	slli s4, t3, 3
	add s4, s4, s3

loop_tokenizer:
	#Carrega a frequência atual em s5
	lw s5, 4(s4)

	#Se for zero, espaço livre
	beq s5, x0, salva_token

	#Caso não seja zero, precisa comparar pra determinar a atualização
	addi sp, sp,  -12
	sw s5, 0(sp)
	sw a1, 4(sp)
	sw t0, 8(sp)

	lw s5, 0(s4) #s5 -> Endereço da palavra na heap
	
	lb t0, 0(t6) #t0 -> Caractere finalizador do token

	sb x0, 0(t6)

	mv a0, t5
	mv a1, s5
	jal strcomp

	sb t0, 0(t6)

	lw s5, 0(sp)
	lw a1, 4(sp)
	lw t0, 8(sp)
	addi sp, sp,  12

	#a0 -> Contém se as strings são iguais

	#Caso não as strings não sejam iguais, incrementa a posição do hash
	beq a0, x0, atualiza_posicao_hash

	lw s6, 4(s4)
	addi s6, s6, 1
	sw s6, 4(s4)
	
atualiza_ponteiro_tokenizer:
    #Atualiza os ponteiros para procurar novos tokens
	
	lb t0, 0(t6)
	beq t0, x0, fim_tokenizer
	addi t6, t6, 1
	add t5, t6, x0
	j testa_caractere

salva_token: #Armazena o token na tabela, com frequência um
	
	#Chamada de sistema para abrir espaço na heap para a string
	addi sp, sp,  -4
	sw t4, 0(sp)
	
	addi t4, t4, 1
	mv a0, t4
	li a7, 9
	ecall

	lw t4, 0(sp)
	addi sp, sp, 4

	#a0 -> Contém o endereço da string na heap

	#Chama a função de copy, para armazenar a o token no espaço da heap
	addi sp, sp,  -8
	sw a1, 0(sp)
	sw a2, 4(sp)

	mv a1, t5
	mv a2, t4

	jal strncpy

	lw a1, 0(sp)
	lw a2, 4(sp)
	addi sp, sp, 8

	#a0 -> Início da string na Heap

	#Armazena na HashTable o endereço da Heap e a Frequência
	addi s5, s5, 1
	sw s5, 4(s4)
	sw a0, 0(s4)
	j atualiza_ponteiro_tokenizer

atualiza_posicao_hash:
	addi s4, s4, 8

	bne s4, s8, loop_tokenizer

	mv s4, s3
	j loop_tokenizer

fim_tokenizer: 
	mv a0, s3
    lw ra, 28(sp)
    lw t0, 24(sp)
    lw t1, 20(sp)
    lw t2, 16(sp)
	lw s3, 12(sp)
	lw t4, 8(sp)
    lw t5, 4(sp)
    lw t6, 0(sp)
	addi sp, sp, 32

	ret