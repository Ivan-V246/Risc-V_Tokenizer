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
