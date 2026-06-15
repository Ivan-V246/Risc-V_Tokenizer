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
# 
# t0 -> Letra atual/Caractere final da Palavra
# t1 -> Primeiro ponteiro/Início da Palavra
# t2 -> Segundo ponteiro/Fim da Palavra
# t3 -> Tamanho da palavra 
# t4 -> Hash do token/Posição na tabela
# t5 -> Frequência
#
# s1 -> Constante 'a'
# s2 -> Constante 'z'
# s3 -> Endereço base da HashTable
# s4 -> Tamanho da HashTable
# s5 -> Maior endereço possível da HashTable
#
# ==============================================================================

.data 
	a: .ascii "a"
	z: .ascii "z"

.text
.globl tokenizer

tokenizer:
	# Guarda contexto anterior
	addi sp, sp, -48
    sw ra, 0(sp)

	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	sw t5, 24(sp)

	sw s1, 28(sp)
	sw s2, 32(sp)
	sw s3, 36(sp)
	sw s4, 40(sp)
	sw s5, 44(sp)

    # Inicialização
	# Letras 'a' (s1) e 'z'(s2) para comparação
	# Endereço base da HashTable (s3)
	# Tamanho da HashTable(s4)
	# Ponteiros t1 e t2 para delimitar os tokens
	# Maior endereço possível da HashTable (s5)
	
	la s1, a
	lb s1, 0(s1)
	
	la s2, z
	lb s2, 0(s2)

	mv s3, a1 
	mv s4, a2

	mv t1, a0
	mv t2, a0
	
	slli s5, s4, 3
	add s5, s5, s3 
	
testa_caractere:
    # Carrega o caractere atual
	lb t0, 0(t2)
	
	# Se for diferente de uma letra chama o separador de token
	blt t0, s1, separador_token
	bgt t0, s2, separador_token

	# Senão, avança para o próximo caractere
	addi t2, t2, 1
	j testa_caractere
	
separador_token:
    # Se os ponteiros forem iguais (token vazio) atualiza eles	
	beq t1, t2, ignora_delimitador

	# Senão precisa salvar o token

    sub t3, t2, t1

	# Chama Hashfunc para calcular o Hash
	mv a0, t1
	mv a1, t3
	mv a2, s4

	jal hashfunc # a0 -> Contém o valor de Hash do token atual

	slli t4, a0, 3 
	add t4, t4, s3 
	# t4 -> Contém o endereço do ponteiro da string na HashTable
	# (t4+4) -> Contém a frequência da string na HashTable

loop_tokenizer:
	# Carrega a frequência referente ao token atual
	lw t5, 4(t4)

	# Se a frequência for zero é um espaço livre, precisa salvar o token
	beq t5, x0, salva_token

	# Senão, precisa comparar as strings
	
	# Salva o caractere final da string, substituindo-o por /0 para comparação
	lb t0, 0(t2) 

	sb x0, 0(t2)

	mv a0, t1
	lw a1, 0(t4)
	jal strcomp # a0 -> Contém se as strings são iguais

	# Restitui o caractere final da string
	sb t0, 0(t2)

	# Se as strings forem diferentes, incrementa a posição do hash
	bne a0, x0, atualiza_posicao_hash

	# Senão, incrementa a frequência
	addi t5, t5, 1
	sw t5, 4(t4)
	
atualiza_ponteiro_tokenizer:
    # Atualiza os ponteiros para procurar novos tokens
	lb t0, 0(t2)

	# Se o atual é um /0, esse é o fim da string
	beq t0, x0, fim_tokenizer

	# Senão, alinha os ponteiros e testa o próximo caractere
	addi t2, t2, 1
	mv t1, t2

	j testa_caractere

ignora_delimitador:
    lb t0, 0(t2)
    beq t0, x0, fim_tokenizer
    addi t2, t2, 1
    mv t1, t2
    j testa_caractere

salva_token: 	
	# Chamada de sistema para abrir espaço na heap para a string
	addi a0, t3, 1
	li a7, 9
	ecall # a0 -> Contém o endereço da string na heap

	# Chama a função de copy, para armazenar o token no espaço da heap
	mv a1, t1
	mv a2, t3

	jal strncpy # a0 -> Início da string na Heap

	# Armazena na HashTable o endereço da Heap e a Frequência 1
	li t5, 1
	sw t5, 4(t4)
	sw a0, 0(t4)

	j atualiza_ponteiro_tokenizer

atualiza_posicao_hash:
	addi t4, t4, 8

	# Se posição atual for diferente da maior possível, testa se está desocupada
	bne t4, s5, loop_tokenizer

	# Senão, volta pra primeira possível, sendo circular 
	mv t4, s3

	j loop_tokenizer

fim_tokenizer: 
	# Armazena o endereço da HashTable preenchida em a0
	mv a0, s3
    
	# Restaura o contexto
	lw ra, 0(sp)

	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	lw t5, 24(sp)

	lw s1, 28(sp)
	lw s2, 32(sp)
	lw s3, 36(sp)
	lw s4, 40(sp)
	lw s5, 44(sp)

	addi sp, sp, 48
    ret
