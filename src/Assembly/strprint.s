# ==============================================================================
# Função: strprint
# Descrição: Muda todas as letras de uma string terminada em zero (asciz) de maiúsculos para minusculos
#
# @param a0: Ponteiro para o endereço base da Hash Table
# @param a1: Tamanho da Hash Table
#
# @return: Void, não tem nenhum retorno
# ==============================================================================
.data
    titulo: .asciz "Palavra \t---->\t Frequência"
    aux: .asciz "          \t---->\t"

.text
.globl strprint
strprint:
    #Print dos resultados
    mv t0, a0
    la a0, titulo
    li a7, 4
    ecall

    li a0, 10
    li a7, 11
    ecall

    li a0, 10
    li a7, 11
    ecall

    loop_strprint:
        beq t0, x0, fim_strprint
        lw a0, 0(t0)
        li a7, 4
        ecall

        la a0, aux
        li a7, 4
        ecall
        
        lw a0, 4(t0)
        li a7, 1
        ecall

        li a0, 10
        li a7, 11
        ecall

        addi, t0, t0, 8
        j loop_strprint

fim_strprint:
    ret
