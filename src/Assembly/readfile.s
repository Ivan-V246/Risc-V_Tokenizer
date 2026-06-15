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
    buffer: .space 200000
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

    # Ler do arquivo
    li a7, 63
    mv a0, s0
    la a1, buffer
    li a2, 199999
    ecall

    # Adiciona o /0 ao final
    la t0, buffer
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
    la a0, buffer
    jalr x0, ra, 0  
