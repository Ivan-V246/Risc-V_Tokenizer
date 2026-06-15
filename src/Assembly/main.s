.data 
    HashTable:   .space 80056
    HashTableSize:   .word 10007
    file: .asciz "/home/agso/Codes/Assembly/riscv/Risc-V_Tokenizer/texts/noites_brancas_tratado.txt"
    titulo: .asciz "Palavra ---> Frequência"
    aux: .asciz " ---> "
    frase: .asciz "Venha Ficar SLA venha, venha.hy ficar, agora, sl, hy hy hy.hy"

.text
.globl main

main:
    #Chama Readfile pra ler o texto
    la a0, file
    jal readfile # Retorna o texto em a0

    #Chama StrToLower para fazer o tratamento de maiúsculas
    jal strtolower

    #Chama Tokenizer para realizar a Tokenização
    la a1, HashTable

    la a2, HashTableSize
    lw a2, 0(a2)
 
    jal tokenizer

    #Chama Ordenador pra organizar a tabela
    la a0, HashTable
    la a1, HashTableSize
    lw a1, 0(a1)
    li a2, 8
    li a3, 1

    jal SORTBUCK

    #Print dos resultados
    la t0, HashTableSize
    lw t0, 0(t0)
    mv t2, a0

    la a0, titulo
    li a7, 4
    ecall

    li a0, 10
    li a7, 11
    ecall
    ecall

loop_print:
    lw t1, 4(t2)

    beq t1, x0, not_print

    lw t1, 0(t2)
    
    mv a0, t1
    li a7, 4
    ecall

    la a0, aux 
    ecall

    lw t1, 4(t2)

    mv a0, t1
    li a7, 1
    ecall

    li a0, 10
    li a7, 11
    ecall

not_print:
    addi t0, t0, -1
    addi t2, t2, 8
    beq t0, x0, e
    j loop_print
      
e: 
	li a7, 10
	ecall
