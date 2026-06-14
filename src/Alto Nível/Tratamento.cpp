#include "Tratamento.h"
using namespace std;

int main() {
    FILE* from = fopen("./../../texts/noites_brancas.txt", "r");
    FILE* dest = fopen("./../../texts/noites_brancas_tratado.txt", "w");
    char linha[1024];
    while(fgets(linha, 1024, from)) {
        fprintf(dest, limpa(linha).c_str());
    }

    fclose(dest);
    fclose(from);
}