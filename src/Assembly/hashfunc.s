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
	addi sp, sp, -24
    sw t0, 20(sp)
    sw t1, 16(sp)
    sw t2, 12(sp)
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

    lw t0, 20(sp)
    lw t1, 16(sp)
    lw t2, 12(sp)
	lw t4, 8(sp)
    lw t5, 4(sp)
    lw t6, 0(sp)
    addi sp, sp, 24

    ret

