#!/bin/bash


while true; do
    clear
    echo "=============================="
    echo "       MENU PRINCIPAL         "
    echo "=============================="
    echo "1. Escolher entrada de teste"
    echo "2. Rodar testes"
    echo "3. exibir comparação"
    echo "4. Sair"
    echo "=============================="

    read -p "Escolha uma opção (1-4): " opcao

    case $opcao in
        1)
            clear
            echo "1 - Escolher arquivo da pasta texts"
            echo "2 - Entrada padrão"
            read -p "Escolha uma opção (1-2): " op 

            case $op in 
                1)
                    ls texts/ | grep "tratado"
                    read -p "Digite o nome do arquivo: " entrada
                    cat texts/$entrada > texts/inputRiscV.txt
                    cat texts/$entrada > texts/inputCpp.txt
                    ;;
                2)
                    read -p "Entre com o texto que deseja utilizar: " entrada
                    echo $entrada > texts/inputCpp.txt
                    echo $entrada > texts/inputRiscV.txt
                    ;;
                *)
                    echo "Opção inválida, entrada não alterada"
                    ;;
            esac
            ;;
        2)
            ROOT_DIR=$(pwd)
            echo "----- Rodando Versão do código em Risc V -----"
            cd src/Assembly
            java -jar /usr/local/bin/rars.jar nc sm *.s > ../../texts/OutputRiscV.txt 
            cat ../../texts/OutputRiscV.txt | head
            sleep 2

            echo "----- Rodando Versão do código em C++ -----"

            cd $ROOT_DIR/src/Alto_nivel
            g++ -o tokenizer tokenizer.cpp
            ./tokenizer > ../../texts/OutputCpp.txt
            rm tokenizer
            cat ../../texts/OutputCpp.txt | head 
            sleep 2

            cd $ROOT_DIR
            echo "----- Testes finalizados -----"

            diff -q texts/OutputCpp.txt texts/OutputRiscV.txt > /dev/null

            if [ $? -eq 0 ]; then
                echo -e "Tudo certo, nenhuma diferença encontrada"
            else
                echo -e "\nForam encontradas algumas diferenças"
                echo "C++                                   |                       Risc-V"
                echo "-------------------------------------------------------------------------------------"

                diff -y --color=always --suppress-common-lines texts/OutputCpp.txt texts/OutputRiscV.txt

            fi 
            read -p "Digite enter para voltar ao menu: " enter
            ;;
        3)
            clear 

            echo "C++                                             |               Risc-V"
            echo "---------------------------------------------------------------------------------------------------------"
            diff -y --color=always texts/OutputCpp.txt texts/OutputRiscV.txt | less
            read -p "Digite enter para voltar: " enter 
            ;;
        4)
            echo "Saindo..."
            break
            ;;
            
        *)
            echo "Opção inválida! Tente novamente."
            sleep 1
            ;;

    esac

done
