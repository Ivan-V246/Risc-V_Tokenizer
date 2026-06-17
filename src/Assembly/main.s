# ==============================================================================
# Função: main
# Descrição: Função principal do programa, responsável por comandar a execução
# ==============================================================================

.data 
    HashTable:   .space 80056
    HashTableSize:   .word 10007
    tmp_key: .space 8
    file: .asciz "../../texts/inputRiscV.txt"
    
.text
.globl main

main:
    #Chama Readfile pra ler o texto
    la a0, file
    jal readfile

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
    la a4, tmp_key

    jal SORTBUCK

    #Print dos resultados
    la a0, HashTable
    la a1, HashTableSize
    lw a1, 0(a1)
    jal strprint

fim:
    li a7, 10
    ecall

