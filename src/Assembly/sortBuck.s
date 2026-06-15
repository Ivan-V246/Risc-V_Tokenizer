# =====================================================================================================
# Função: sortBuck
# Descrição: Ordena os buckets.
# Bucket: Estrutura de dados de N bytes nos quais os são escolhidos 4 bytes para como valor de ordenação    
# Algoritmo de ordenação: ShellSort

# @param a0: Endereço base da Hash Table para ser ordenado. 
# @param a1: Quantidade de buckets no array.
# @param a2: Tamanho de cada buckets do array.
# @param a3: Index do valor de ordenação.
# @param a4: Espaco de memoria para guarda dados temporarios
# =====================================================================================================

# =======================================================
# t1: gap do shellsort.
# t2: Interador "I".
# t3: Interador "J".
# =======================================================

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
            mv t6, a4

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
                addi t0, x0, 4
                mul t0, t0, a3
                mv t4, a4
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
	            mv t6, a4
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
