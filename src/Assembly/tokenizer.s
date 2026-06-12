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
	sw t3, 12(sp)
	sw t4, 8(sp)
    sw t5, 4(sp)
    sw t6, 0(sp)

    #Inicializa os dois ponteiros, e as letras 'a' e 'z' para comparação
	mv t3, a1

	mv t5, a0
	add t6, t5, x0
	
	la t1, a
	lbu t1, 0(t1)
	
	la t2, z
	lbu t2, 0(t2)
	
testa_caractere:
    #Carrega o caractere e imprime na tela caso esteja entre 'a' e 'z'
	
	lbu t0, 0(t6)
	blt t0, t1, not_letra
	bgt t0, t2, not_letra

	addi t6, t6, 1
	j testa_caractere
	
not_letra:
    #Caso não seja letra, checa se os ponteiros são diferentes para salvar o token
	
	beq t5, t6, atualiza_ponteiro_tokenizer

    sub t4, t6, t5

	#Chama Hashfunc, a0 -> Hash do Token
	mv a0, t5
	mv a1, t4
	jal hashfunc

	li a7, 1
    ecall

	addi t0, x0, 10
	li a7, 11
	add a0, t0, x0
	ecall
	
atualiza_ponteiro_tokenizer:
    #Atualiza os ponteiros para procurar novos tokens
	
	lbu t0, 0(t6)
	beq t0, x0, fim_tokenizer
	addi t6, t6, 1
	add t5, t6, x0
	j testa_caractere

fim_tokenizer: 
	
    lw ra, 28(sp)
    lw t0, 24(sp)
    lw t1, 20(sp)
    lw t2, 16(sp)
	lw t3, 12(sp)
	lw t4, 8(sp)
    lw t5, 4(sp)
    lw t6, 0(sp)
	addi sp, sp, 32

	ret