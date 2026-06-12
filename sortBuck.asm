# ==============================================================================
# Função: sortBuck
# Descrição: Ordena os bucks de palavra pela freqência.
# Buck: Estrutura de dados de 8 bytes nos quais os primeiros 4 bytes são o endereço base da palavra e os outros 4 bytes são a sua frequêcia  
#
# @param a0: Base do array buck.
# @param a1: Quantidade de elementos no array buck.    
# a0: Base do array para ser ordenado 
# a1: Tamanho de cada objeto 
# a2: Quantidade de bytes total do array
# a3: Gap do sheellsort
# a4: guarda o valor 1 para comparacao 
# a5: guarda 3 para operacoes

.data 
	ARRAY: .word -1, 0, 200, 19, 3, 50, 61, 55, 22, 9, 45, 23 # Array com os valores a ser ordenado
	SIZE_ARRAY: .word 12 # Tamanho do array
	BYTES_OBJECT: .word 4 # Tamanho de cada objeto no array
	
.text
.globl SORTBUCK

SORTBUCK:
    # Salva o estado anterior na pilha
    addi sp, sp, -12
    sw t0, 8(sp)
    sw t1, 4(sp)
    sw ra, 0(sp)

    INIT_SORTBUCK: 
        la a0, ARRAY # a0 = ARRAY   
        
        # t1 = *SIZE_ARRAY
        la t1, SIZE_ARRAY
        lw t1, 0(t1) 
        
        # a1 = *BYTES_OBJECT
        la a1, BYTES_OBJECT 
        lw a1, 0(a1) 
                
        # a2 = SIZE_ARRAY * BYTES_OBJECT
        mul a2, a1, t1 
        
        # FIND_GAP
            # gap = 1
            addi a3, x0, 1
            addi a5, x0, 3 
            
        LOOP_GAP:
            # a3 = (a1 * 3) + 1
            mul a3, a3, a5
            addi a3, a3, 1 
            
            blt a3, a2, LOOP_GAP
        
        # a3 = (a3 / 3) -1
        addi a3, a3, -1
        div a3, a3, a5
        
        addi a4, x0, 1 # Guarda 1 para comparacao
        
    WHILE_GAP: 
        blt a3, a4, END_SORTBUCK
        
        # I = gap 
        addi t1, a3, 0
    
        FOR_I:
            # J = I - gap
            sub t2, t1, a3
            
            # key = ARRAY[I]
            mul t3, t1, a1 
            add t3, t3, a0
            lw t3, 0(t3)
            
            WHILE_SWAP:
                blt t2, x0, NEXT_KEY
                
                # t4 = ARRAY[J]
                mul t4, t2, a1
                add t4, t4, a0
                lw t4, 0(t4) 
                
                bge t3, t4, NEXT_KEY 
                
                # PARTE SWAP
                # ARRAY[J + gap] = ARRAY[j] 
                add t5, t2, a3
                mul t5, t5, a1
                add t5, t5, a0
                sw t4, 0(t5)
                
                # J -= gap
                sub t2, t2, a3 
                
                jal x0, WHILE_SWAP
            
            NEXT_KEY: 
                # ARRAY[J + gap] = ARRAY[j] 
                add t5, t2, a3
                mul t5, t5, a1
                add t5, t5, a0
                sw t3, 0(t5) 
                
                # I = I + 1
                addi t1, t1, 1
                mul t5, t1, a1
                blt t5, a2, FOR_I
                
                addi a3, a3, -1
                div a3, a3, a5
                
                jal x0, WHILE_GAP
        
END_SORTBUCK:
    # Volta o estado anterior
    lw t0, 8(sp)
    lw t1, 4(sp)
    lw ra, 0(sp)
    addi sp, sp, 12
    jalr x0, ra, 0 
    ebreak