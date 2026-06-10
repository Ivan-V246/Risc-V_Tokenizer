# ==============================================================================
# Função: hashfunc
# Descrição: Calcula o hash de uma string terminada em nulo (asciz) 
#            usando o algoritmo djb2 e calcula o indice da tabela
#
# @param a0: Ponteiro para o endereço base da string.
# @param a1: Tamanho da Tabela Hash.

# @return a0: O índice calculado para a Tabela Hash.
# ==============================================================================

.text
.globl hashfunc
hashfunc:
    li t0, 5381

    loop_hashfunc:
        lb t1, 0(a0)
        beq x0, t1, fim_hashfunc
        
        slli t2, t0, 5
        add t0, t2, t0
        add t0, t0, t1
        
        addi a0, a0, 1

        jal x0, loop_hashfunc


fim_hashfunc:
    remu a0, t0, a1
    ret

