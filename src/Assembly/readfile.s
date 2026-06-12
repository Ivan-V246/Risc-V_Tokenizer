.data
    file: .asciz "/home/agso/UFPI/Materias/Terceiro-periodo/Arquitetura/Trabalho/noites_brancas_tratado.txt"
    err: .asciz "Fudeu o arquivo"
    buffer: .space 200000
.text
.globl readfile

readfile:
    # Abrir arquivo
    li a7, 1024
    la a0, file
    li a1, 0
    ecall

    li t0, -1
    beq a0, t0, file_error

    mv s0, a0

    # Ler do arquivo
    li a7, 63
    add a0, s0, x0
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
    li a7, 4
    la a0, err
    ecall

    li a7, 93
    li a0, 0
    ecall
fim:
    la a0, buffer
    jalr x0, ra, 0  




    li a7, 1
	ecall

	addi t0, x0, 10
	li a7, 11
	add a0, t0, x0
	ecall
