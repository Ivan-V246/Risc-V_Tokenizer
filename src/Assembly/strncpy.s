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
    addi sp, sp, -4
    sw a0, 0(sp)
    
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

    lw a0, 0(sp)
    addi sp, sp, 4
    ret


