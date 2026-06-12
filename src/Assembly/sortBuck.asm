# ==============================================================================
# Função: sortBuck
# Descrição: Ordena os bucks de palavra pela freqência.
# Buck: Estrutura de dados de 8 bytes nos quais os primeiros 4 bytes são o endereço base da palavra e os outros 4 bytes são a sua frequêcia  
#    
# @param a0: Base do array para ser ordenado. 
# @param a1: Quantidade de elemento no array.
# @param a2: Tamanho de cada elemento do array.
# @param a3: Index de ordenação.

# a3: Gap do sheellsort
# a4: guarda o valor 1 para comparacao 
# a5: guarda 3 para operacoes

# t1: gap 
# t2: I
# t3: J

.data 
	ARRAY: .word 8, 2, -10, 1, 6, 5, 3, 10, 4 # Array com os valores a ser ordenado
	SIZE_ARRAY: .word 3 # Tamanho do array
	BYTES_OBJECT: .word 12 # Tamanho de cada objeto no array
    INDEX_SORT: .word 2 # Index de ordenacao de cada objeto
	TMP_KEY: .space 12 # Temporario para key
	
.text
.globl SORTBUCK

SORTBUCK:
    # Salva o estado anterior na pilha
    #addi sp, sp, -12
    #sw t0, 8(sp)
    #sw t1, 4(sp)
    #sw ra, 0(sp)
  
    INIT: 
        la a0, ARRAY # a0 = ARRAY   
        
        # a1 = *SIZE_ARRAY
        la a1, SIZE_ARRAY
        lw a1, 0(a1) 
        
        # a2 = *BYTES_OBJECT
        la a2, BYTES_OBJECT 
        lw a2, 0(a2) 
        
        # a3 = *INDEX_SORT 
        la a3, INDEX_SORT
        lw a3, 0(a3)

        # FIND_GAP
        # gap = 1
        addi t1, x0, 1
        addi a5, x0, 3 
            
        LOOP_GAP:
            # a3 = (a1 * 3) + 1
            mul t1, t1, a5
            addi t1, t1, 1 
            
            blt t1, a1, LOOP_GAP
        
        # a3 = (a3 / 3) -1
        addi t1, t1, -1
        div t1, t1, a5
        
        addi a4, x0, 1 # Guarda 1 para comparacao
        
    WHILE_GAP: 
        blt t1, a4, END_SORTBUCK
        
        # I = gap 
        addi t2, t1, 0
    
        FOR_I:
            # J = I - gap
            sub t3, t2, t1
            
            # key = ARRAY[I]
            mul t4, t2, a2
            add t4, t4, a0

            addi t5, a2, 0
            la t6, TMP_KEY 

            # Salva a key em um lugar reservado
            SAVE_KEY:
                lw s0, 0(t4)
                sw s0, 0(t6)

                addi t4, t4, 4
                addi t6, t6, 4
                addi t5, t5, -4

                bne t5, x0, SAVE_KEY 
            
            # Index de ordenacao
            sub t4, t4, a2
            addi t5, x0, 4
            mul t5, t5, a3
            add t4, t4, t5 
            lw t4, 0(t4) # t5 = key 
            
            WHILE_SWAP:
                blt t3, x0, NEXT_KEY
                
                # Index de ordenacao do elemento J
                mul t5, t3, a2
                addi t6, x0, 4
                mul t6, t6, a3
                add t5, t5, t6
                add t5, t5, a0
                lw t6, 0(t5) 
                
                bge t6, t4, NEXT_KEY 
                
                # End[j + gap] 
                add t5, t3, t1
                mul t5, t5, a2
                add t5, t5, a0

                # End[j]
                add t6, t3, x0
                mul t6, t6, a2
                add t6, t6, a0

                # M[j + gap] = M[j]
                addi a6, a2, 0
                PUSH_J:
                    lw s0, 0(t6)
                    sw s0, 0(t5)

                    addi t6, t6, 4
                    addi t5, t5, 4
                    addi a6, a6, -4

                    bne a6, x0, PUSH_J
                
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
                addi a6, a2, 0

                WRITE_KEY:
                    lw s0, 0(t6)
                    sw s0, 0(t5)

                    addi t6, t6, 4
                    addi t5, t5, 4
                    addi a6, a6, -4

                    bne a6, x0, WRITE_KEY 
                
                addi t2, t2, 1
                blt t2, a1, FOR_I
                
                addi t1, t1, -1
                div t1, t1, a5
                
                jal x0, WHILE_GAP 

END_SORTBUCK:
    # Volta o estado anterior
    #lw t0, 8(sp)
    #lw t1, 4(sp)
    #lw ra, 0(sp)
    #addi sp, sp, 12
    #jalr x0, ra, 0
    ebreak