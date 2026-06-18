# Trabalho em Grupo - Arquitetura de Computadores: Tokenizer

![C++](https://img.shields.io/badge/C++-17-blue?logo=cplusplus&logoColor=white)
![RISC-V RV32I](https://img.shields.io/badge/RISC--V-RV32I-yellow?logo=riscv&logoColor=white)
![Git](https://img.shields.io/badge/Git-Versionamento-orange?logo=git&logoColor=white)

Projeto desenvolvido para a disciplina de Arquitetura de Computadores, aplicado à área de Processamento de Linguagem Natural (PLN). O objetivo é implementar duas soluções para gerar o histograma de frequência dos tokens presentes em um texto, utilizando uma linguagem de alto nível e uma linguagem de baixo nível.

---

## Integrantes do Grupo

* **Gleidson Luan Sena Alves**
* **Ivan Vitor Dias de Oliveira**
* **Antonio Gemesson Sousa de Oliveira**

---

# Projeto

## 1. Objetivo

Extrair a frequência dos tokens presentes em um texto, ou seja:

* Tokenizar o texto, identificando cada palavra presente;
* Contabilizar a frequência de ocorrência de cada token;
* Associar corretamente cada token à sua respectiva frequência;
* Gerar um histograma contendo as frequências encontradas.

Além da resolução do problema, o projeto também propõe a comparação dos resultados obtidos por implementações desenvolvidas em linguagens de diferentes níveis de abstração.

---

## 2. Ferramentas Utilizadas

* **[C++](https://devdocs.io/cpp/)** - Linguagem de alto nível utilizada para implementar a solução de referência.
* **[Git](https://git-scm.com/)** - Ferramenta de versionamento e controle de código-fonte.
* **[RISC-V RV32I](https://riscv.org/specifications/ratified/)** - Arquitetura e linguagem Assembly utilizadas para a implementação em baixo nível.
* **[RARS](https://github.com/TheThirdOne/rars)** - Simulador utilizado para executar os programas em Assembly RISC-V.

---

## 3. Proposta de Solução

Tanto a implementação em C++ quanto a implementação em RISC-V seguem o mesmo fluxo de execução:

1. Leitura do texto de entrada;
2. Tokenização do texto;
3. Armazenamento dos tokens e suas frequências em uma estrutura de dados do tipo Hash;
4. Ordenação dos tokens de acordo com suas frequências;
5. Geração e exibição do histograma de frequência.

---

## 4. Estrutura do Projeto

A organização do projeto foi dividida em três partes principais: implementação em alto nível, implementação em baixo nível e arquivos de entrada e saída utilizados durante os testes.

```text
Risc-V_Tokenizer
├── README.md
├── run.sh
├── src
│   ├── Alto_nivel
│   │   ├── tokenizer.cpp
│   │   ├── Tratamento.cpp
│   │   └── Tratamento.h
│   ├── Alto Nível
│   │   └── main.exe
│   └── Assembly
│       ├── hashfunc.s
│       ├── main.s
│       ├── readfile.s
│       ├── sortbucket.s
│       ├── strcomp.s
│       ├── strncpy.s
│       ├── strprint.s
│       ├── strtolower.s
│       └── tokenizer.s
└── texts
    ├── inputCpp.txt
    ├── inputRiscV.txt
    ├── noites_brancas_tratado.txt
    ├── noites_brancas.txt
    ├── no_meio_do_caminho_tratado.txt
    ├── no_meio_do_caminho.txt
    ├── OutputCpp.txt
    └── OutputRiscV.txt
```

### Descrição dos Diretórios

#### src/Alto_nivel

Contém a implementação da solução em C++.

* `tokenizer.cpp` - Programa principal responsável pela tokenização e geração do histograma.
* `Tratamento.cpp` - Implementação das rotinas de tratamento do texto.
* `Tratamento.h` - Arquivo de cabeçalho contendo as definições utilizadas pelas rotinas de tratamento.

####  src/Assembly

Contém a implementação da solução em Assembly RISC-V RV32I.

* `main.s` - Ponto de entrada do programa.
* `readfile.s` - Rotinas de leitura do texto de entrada.
* `tokenizer.s` - Responsável pela tokenização do texto.
* `hashfunc.s` - Implementação da função hash utilizada para armazenamento dos tokens.
* `sortbucket.s` - Rotinas de ordenação das frequências.
* `strcomp.s` - Comparação de strings.
* `strncpy.s` - Cópia de strings.
* `strprint.s` - Impressão de strings.
* `strtolower.s` - Conversão de caracteres para letras minúsculas.

#### texts

Armazena os arquivos de entrada e saída utilizados durante os testes.

#### Arquivos da Raiz

* `README.md` - Documentação do projeto.
* `run.sh` - Script responsável pela execução dos testes e comparação automática dos resultados.

---

# Funcionalidades

## Escolha da Entrada

Permite definir o texto utilizado nos testes de duas formas:

* **Arquivo de teste:** seleção de um arquivo localizado na pasta `texts/`;
* **Entrada manual:** digitação direta do texto pelo usuário.

A entrada escolhida é automaticamente disponibilizada para as implementações em C++ e RISC-V.

---

## Execução dos Testes

Executa automaticamente as duas versões da solução:

1. Implementação em **RISC-V Assembly**, utilizando o simulador RARS;
2. Implementação em **C++**.

As saídas produzidas por cada implementação são armazenadas em arquivos para posterior comparação.

---

## Comparação Automática dos Resultados

Após a execução dos testes, as saídas geradas pelas duas implementações são comparadas automaticamente.

* Caso os resultados sejam idênticos, uma mensagem de sucesso é exibida;
* Caso existam divergências, as diferenças encontradas são destacadas.

---

## Visualização Detalhada das Diferenças

Permite visualizar lado a lado as saídas produzidas pelas implementações em C++ e RISC-V, facilitando a identificação e análise de divergências.

---

# Como Testar

## Pré-requisitos

Certifique-se de possuir os seguintes softwares instalados:

* Git;
* Compilador C++ (`g++`);
* Java Runtime Environment (JRE);
* Simulador RARS (`rars.jar`).

---

## Clonando o Repositório

```bash
git clone https://github.com/Ivan-V246/Risc-V_Tokenizer.git
cd Risc-V_Tokenizer
```

---

## Executando os Testes

Conceda permissão de execução ao script:

```bash
chmod +x run.sh
```

Execute o programa:

```bash
./run.sh
```

---

## Fluxo de Teste

1. Escolha a opção **1** para selecionar a entrada;
2. Escolha uma das alternativas:

   * Arquivo localizado na pasta `texts`;
   * Texto digitado manualmente;
3. Retorne ao menu principal;
4. Escolha a opção **2** para executar os testes;
5. Verifique o resultado da comparação automática;
6. Utilize a opção **3** para visualizar detalhadamente as diferenças encontradas entre as saídas.

---

Os resultados produzidos pelas implementações em C++ e RISC-V devem ser equivalentes, validando a corretude da implementação em baixo nível.
