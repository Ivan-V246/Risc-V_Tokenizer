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

    li a0, 500000
    li a7, 9
    ecall
    mv s1, a0

    # Ler do arquivo
    li a7, 63
    mv a0, s0
    mv a1, s1
    li a2, 499999
    ecall

    # Adiciona o /0 ao final
    mv t0, s1
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
    mv a0, s1
    jalr x0, ra, 0  
