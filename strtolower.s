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


