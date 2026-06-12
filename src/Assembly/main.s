.data 
    HashTable:   .space 79784
    HashTableSize:   .word 9973
    frase: .asciz "hy-ago hyago   im.proprio, the duck  sla ooobbaaaa"

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
    j e
    
e: 
	li a7, 10
	ecall