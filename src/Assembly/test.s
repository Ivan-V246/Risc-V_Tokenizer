# ==============================================================================
# Função: hashfunc
# Descrição: Calcula o hash de uma string terminada em nulo (asciz) 
#            usando o algoritmo djb2 e calcula o indice da tabela
#
# @param a0: Ponteiro para o endereço base da string.
# @param a1: Tamanho da string
# @param a2: Tamanho da Tabela Hash.

# @return a0: O índice calculado para a Tabela Hash.
# ==============================================================================

.text
.globl hashfunc
hashfunc:
	addi sp, sp, -32
    sw ra, 28(sp)
    sw t0, 24(sp)
    sw t1, 20(sp)
    sw t2, 16(sp)
	sw t3, 12(sp)
	sw t4, 8(sp)
    sw t5, 4(sp)
    sw t6, 0(sp)

    li t0, 5381
    mv t3, a1

    loop_hashfunc:
        lb t1, 0(a0)

        addi t3, t3, -1
        
        slli t2, t0, 5
        add t0, t2, t0
        add t0, t0, t1
        
        addi a0, a0, 1

        beq x0, t3, fim_hashfunc
        jal x0, loop_hashfunc


fim_hashfunc:
    remu a0, t0, a2

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

.data 
    HashTable:   .space 80056
    HashTableSize:   .word 10007
    file: .asciz "/home/agso/Codes/Assembly/riscv/Risc-V_Tokenizer/texts/noites_brancas_tratado.txt"
    titulo: .asciz "Palavra ---> Frequência"
    aux: .asciz " ---> "
    frase: .asciz "Venha Ficar SLA venha, venha.hy ficar, agora, sl, hy hy hy.hy"

.text
.globl main

main:
    #Chama Readfile pra ler o texto
    la a0, file
    jal readfile # Retorna o texto em a0

    #Chama StrToLower para fazer o tratamento de maiúsculas
    jal strtolower

    #Chama Tokenizer para realizar a Tokenização
    la a1, HashTable

    la a2, HashTableSize
    lw a2, 0(a2)
 
    jal tokenizer

    #Chama Ordenador pra organizar a tabela
    la a0, HashTable
    la a1, HashTableSize
    lw a1, 0(a1)
    li a2, 8
    li a3, 1

    jal SORTBUCK

    #Print dos resultados
    la t0, HashTableSize
    lw t0, 0(t0)
    mv t2, a0

    la a0, titulo
    li a7, 4
    ecall

    li a0, 10
    li a7, 11
    ecall
    ecall

loop_print:
    lw t1, 4(t2)

    beq t1, x0, not_print

    lw t1, 0(t2)
    
    mv a0, t1
    li a7, 4
    ecall

    la a0, aux 
    ecall

    lw t1, 4(t2)

    mv a0, t1
    li a7, 1
    ecall

    li a0, 10
    li a7, 11
    ecall

not_print:
    addi t0, t0, -1
    addi t2, t2, 8
    beq t0, x0, e
    j loop_print
      
e: 
	li a7, 10
	ecall
# ==============================================================================
# Função: readfile
# Descrição: Lê os bytes de um arquivo em um buffer
#
# @param a0: Nome do arquivo, string asciz
#
# @return: a0: Endereço de memória do buffer com os bytes do arquivo
# ==============================================================================

.data
    err: .asciz "Erro no arquivo"
    buffer: .space 200000
.text
.globl readfile

readfile:
    # Abrir arquivo
    li a7, 1024
    li a1, 0
    ecall

    li t0, -1
    beq a0, t0, file_error

    mv s0, a0

    # Ler do arquivo
    li a7, 63
    mv a0, s0
    la a1, buffer
    li a2, 199999
    ecall

    # Adiciona o /0 ao final
    la t0, buffer
    add t0, t0, a0
    sb zero, 0(t0)

    # Fecha o arquivo
    li a7, 57    
    mv a0, s0         
    ecall

    jal x0, fim
file_error:
    # Printa erro
    li a7, 4
    la a0, err
    ecall

    li a7, 93
    li a0, 0
    ecall
fim:
    la a0, buffer
    jalr x0, ra, 0  
# =====================================================================================================
# Função: sortBuck
# Descrição: Ordena os buckets.
# Bucket: Estrutura de dados de N bytes nos quais os são escolhidos 4 bytes para como valor de ordenação    
# Algoritmo de ordenação: ShellSort

# @param a0: Endereço base da Hash Table para ser ordenado. 
# @param a1: Quantidade de buckets no array.
# @param a2: Tamanho de cada buckets do array.
# @param a3: Index do valor de ordenação.
# =====================================================================================================

# =======================================================
# t1: gap do shellsort.
# t2: Interador "I".
# t3: Interador "J".
# =======================================================

.data
    TMP_KEY: .space 8

.text
.globl SORTBUCK

SORTBUCK:
    # Salva o estado anterior na pilha
    addi sp, sp, -32
    sw t0, 28(sp)
    sw t1, 24(sp)
    sw t2, 20(sp)
    sw t3, 16(sp)
    sw t4, 12(sp)
    sw t5, 8(sp)
    sw t6, 4(sp)
    sw ra, 0(sp)
  
    INIT: 
        # Encontra a sequência de gaps do shellsort 
        addi t1, x0, 1 # gap = 1
        addi t0, x0, 3 

        LOOP_GAP:
            
            # gap = (gap * 3) + 1
            mul t1, t1, t0
            addi t1, t1, 1 
            
            blt t1, a1, LOOP_GAP # if gap < SIZE_ARRAY
        
        # a3 = (a3 / 3) - 1
        addi t1, t1, -1
        div t1, t1, t0
        
    WHILE_GAP: 
        addi t0, x0, 1
        blt t1, t0, END_SORTBUCK # if gap < 1
        
        addi t2, t1, 0 # I = gap

        FOR_I: # for(i=gap; i < SIZE_ARRAY; i++)
            sub t3, t2, t1 # J = I - gap
            
            # key = ARRAY[I]
            mul t4, t2, a2
            add t4, t4, a0

            addi t5, a2, 0 # t5 = BYTES_OBJECT
            la t6, TMP_KEY 

            # Salva a key em um lugar reservado
            SAVE_KEY:
                lw t0, 0(t4)
                sw t0, 0(t6)

                addi t4, t4, 4
                addi t6, t6, 4
                addi t5, t5, -4

                bne t5, x0, SAVE_KEY # while(t5 != 0 )
            
            # Index de ordenacao do elemento I
            # Array[I][orde]
            sub t4, t4, a2
            addi t5, x0, 4
            mul t5, t5, a3
            add t4, t4, t5 
            lw t4, 0(t4) 
            
            WHILE_SWAP:
                blt t3, x0, NEXT_KEY # if gap < 0
                
                # Index de ordenacao do elemento J
                # Array[J][orde]
                mul t5, t3, a2
                addi t6, x0, 4
                mul t6, t6, a3
                add t5, t5, t6
                add t5, t5, a0
                lw t6, 0(t5) 
                
                bge t6, t4, NEXT_KEY # if array[j] >= key 
                
                # [j + gap] 
                add t5, t3, t1
                mul t5, t5, a2
                add t5, t5, a0

                # [j]
                add t6, t3, x0
                mul t6, t6, a2
                add t6, t6, a0

                # Array[j + gap] = Array[j]
                addi t4, a2, 0
                PUSH_J:
                    lw t0, 0(t6)
                    sw t0, 0(t5)

                    addi t6, t6, 4
                    addi t5, t5, 4
                    addi t4, t4, -4

                    bne t4, x0, PUSH_J # while t4 != 0

                # Array[I][orde]
                la t4, TMP_KEY
                addi t0, x0, 4
                mul t0, t0, a3
                add t4, t4, t0 
                lw t4, 0(t4) 
                
                # J -= gap
                sub t3, t3, t1  
                jal x0, WHILE_SWAP
            
            NEXT_KEY: 
                # ARRAY[J + gap] 
                add t5, t3, t1
                mul t5, t5, a2
                add t5, t5, a0
                
                # Recupera key 
	            la t6, TMP_KEY
                addi t4, a2, 0

                WRITE_KEY:
                    lw t0, 0(t6)
                    sw t0, 0(t5)

                    addi t6, t6, 4
                    addi t5, t5, 4
                    addi t4, t4, -4

                    bne t4, x0, WRITE_KEY # while t4 != 0 
                
                addi t2, t2, 1
                blt t2, a1, FOR_I
                
                # gap = (gap -1) / 3
                addi t0, x0, 3
                addi t1, t1, -1
                div t1, t1, t0
                
                jal x0, WHILE_GAP 

END_SORTBUCK:
    # Volta o estado anterior
    lw t0, 28(sp)
    lw t1, 24(sp)
    lw t2, 20(sp)
    lw t3, 16(sp)
    lw t4, 12(sp)
    lw t5, 8(sp)
    lw t6, 4(sp)
    lw ra, 0(sp)
    
    addi sp, sp, 32
    ret
# ==============================================================================
# Função: strcomp
# Descrição: Compara duas strings terminadas em nulo (asciz) caractere por caractere.
#
# @param a0: Ponteiro para o endereço base da primeira string.
# @param a1: Ponteiro para o endereço base da segunda string.
#
# @return a0: 0 se forem identicas, 1 se a primeira string é maior, -1 se a primeira string é menor.
# ==============================================================================

.text
.globl strcomp

strcomp:
    # Salva o estado anterior na pilha
    addi sp, sp, -12
    sw t0, 8(sp)
    sw t1, 4(sp)
    sw ra, 0(sp)
    
    # Comparação
    loop_strcomp:
        lb t0, 0(a0)
        lb t1, 0(a1)
        bne t0, t1, diff_strcomp
        beq x0, t1, equal_strcomp

        addi a0, a0, 1
        addi a1, a1, 1
        jal x0, loop_strcomp

    equal_strcomp:
        li a0, 0
        jal x0, fim_strcomp

    diff_strcomp:
        blt t0, t1, less_strcomp  
        greater_strcomp:
            li a0, 1
            jal x0, fim_strcomp
        less_strcomp:
            li a0, -1
            jal x0, fim_strcomp
        
fim_strcomp:
    # Volta o estado anterior
    lw t0, 8(sp)
    lw t1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 12
    ret
# ==============================================================================
# Função: strncpy
# Descrição: Copia N caracteres de uma string origem para um destino e
#            adiciona automaticamente o terminador nulo (\0) no final.
#
# @param a0: Ponteiro para o endereço de destino.
# @param a1: Ponteiro para o endereço de origem.
# @param a2: Quantidade de bytes para copiar.
#
# @return a0: Ponteiro de destino preenchido com a string.
# ==============================================================================

.text
.globl strncpy

strncpy:
    addi sp, sp, -36
    sw a0, 32(sp)
    sw ra, 28(sp)
    sw t0, 24(sp)
    sw t1, 20(sp)
    sw t2, 16(sp)
	sw t3, 12(sp)
	sw t4, 8(sp)
    sw t5, 4(sp)
    sw t6, 0(sp)
    
    loop_strncpy: 
        beq x0, a2, fim_strncpy
        
        lb t0, 0(a1)
        sb t0, 0(a0)

        addi a0, a0, 1
        addi a1, a1, 1
        addi a2, a2, -1

        jal x0, loop_strncpy
        
fim_strncpy:
    addi a0, a0, 1
    sb x0, 0(a0)

    lw a0, 32(sp)
    lw ra, 28(sp)
    lw t0, 24(sp)
    lw t1, 20(sp)
    lw t2, 16(sp)
	lw t3, 12(sp)
	lw t4, 8(sp)
    lw t5, 4(sp)
    lw t6, 0(sp)
    addi sp, sp, 36

    ret


# ==============================================================================
# Função: tolower
# Descrição: Muda todas as letras de uma string terminada em zero (asciz) de maiúsculos para minusculos
#
# @param a0: Ponteiro para o endereço base da string.
#
# @return: Void, modifica a memória diretamente
# ==============================================================================

.text
.globl strtolower

strtolower:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw a0, 12(sp)
    sw t0, 8(sp)
    sw t1, 4(sp)
    sw t2, 0(sp)

    li t0, 65
    li t1, 91

    loop_strtolower:
        lb t2, 0(a0)
        beq x0, t2, fim_strtolower

        bge t2, t1, avanca_ponteiro_strtolower
        blt t2, t0, avanca_ponteiro_strtolower
        
        addi t2, t2, 32
        sb t2, 0(a0)

    avanca_ponteiro_strtolower:
        addi a0, a0, 1
        jal x0, loop_strtolower

fim_strtolower:
    lw ra, 16(sp)
    lw a0, 12(sp)
    lw t0, 8(sp)
    lw t1, 4(sp)
    lw t2, 0(sp)
    addi sp, sp, 20
    
    jalr x0, ra, 0


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
	beq t1, t2, atualiza_ponteiro_tokenizer

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
