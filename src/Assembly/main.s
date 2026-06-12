.data 
    HashTable:   .space 80056
    HashTableSize:   .word 10007
    frase: .asciz "venha ficar venha, venha.hy ficar, agora, sl, hyhyhy.hy"

.text
.globl main

main:
    #Chama Readfile pra ter o texto
    #Chama ToLower para fazer o tratamento de maiúsculas
    #Chama Tokenizer para realizar a tokenização
    #Chama Ordenador pra organizar a tabela

    la s0, frase
    mv a0, s0

    la s0, HashTable
    mv a1, s0

    la s0, HashTableSize
    lw a2, 0(s0)
 
    jal tokenizer

    la t0, HashTableSize
    lw t0, 0(t0)
    mv t2, a0

loop_main:
    lw t1, 4(t2)

    beq t1, x0, nprinta

    lw t1, 0(t2)
    
    mv a0, t1
    li a7, 4
    ecall

    li a0, 32
    li a7, 11
    ecall

    lw t1, 4(t2)

    mv a0, t1
    li a7, 1
    ecall

    li a0, 10
    li a7, 11
    ecall

nprinta:
    addi t0, t0, -1
    addi t2, t2, 8
    beq t0, x0, e
    j loop_main
      
e: 
	li a7, 10
	ecall