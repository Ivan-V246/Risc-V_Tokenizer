#include <bits/stdc++.h>
using namespace std;

#define pii pair<int, int>
#define mkp make_pair

#define num (unsigned int)(unsigned char)

//Dicionário de caracteres especias a serem retirados
map<pii, char> acentos = {
    mkp(mkp(0xc3, 0x80), 'a'), // À
    mkp(mkp(0xc3, 0x81), 'a'), // Á
    mkp(mkp(0xc3, 0x82), 'a'), // Â
    mkp(mkp(0xc3, 0x83), 'a'), // Ã

    mkp(mkp(0xc3, 0xA0), 'a'), // à
    mkp(mkp(0xc3, 0xA1), 'a'), // á
    mkp(mkp(0xc3, 0xA2), 'a'), // â
    mkp(mkp(0xc3, 0xA3), 'a'), // ã

    mkp(mkp(0xc3, 0x87), 'c'), // Ç
    mkp(mkp(0xc3, 0xA7), 'c'), // ç

    mkp(mkp(0xc3, 0x88), 'e'), // È
    mkp(mkp(0xc3, 0x89), 'e'), // É
    mkp(mkp(0xc3, 0x8A), 'e'), // Ê

    mkp(mkp(0xc3, 0xA8), 'e'), // è
    mkp(mkp(0xc3, 0xA9), 'e'), // é
    mkp(mkp(0xc3, 0xAA), 'e'), // ê

    mkp(mkp(0xc3, 0x8C), 'i'), // Ì
    mkp(mkp(0xc3, 0x8D), 'i'), // Í
    mkp(mkp(0xc3, 0x8E), 'i'), // Î

    mkp(mkp(0xc3, 0xAC), 'i'), // ì
    mkp(mkp(0xc3, 0xAD), 'i'), // í
    mkp(mkp(0xc3, 0xAE), 'i'), // î

    mkp(mkp(0xc3, 0x92), 'o'), // Ò
    mkp(mkp(0xc3, 0x93), 'o'), // Ó
    mkp(mkp(0xc3, 0x94), 'o'), // Ô
    mkp(mkp(0xc3, 0x95), 'o'), // Õ

    mkp(mkp(0xc3, 0xB2), 'o'), // ò
    mkp(mkp(0xc3, 0xB3), 'o'), // ó
    mkp(mkp(0xc3, 0xB4), 'o'), // ô
    mkp(mkp(0xc3, 0xB5), 'o'), // õ

    mkp(mkp(0xc3, 0x99), 'u'), // Ù
    mkp(mkp(0xc3, 0x9A), 'u'), // Ú
    mkp(mkp(0xc3, 0x9B), 'u'), // Û
    mkp(mkp(0xc3, 0x9C), 'u'), // Ü

    mkp(mkp(0xc3, 0xB9), 'u'), // ù
    mkp(mkp(0xc3, 0xBA), 'u'), // ú
    mkp(mkp(0xc3, 0xBB), 'u'), // û
    mkp(mkp(0xc3, 0xBC), 'u')  // ü

};

//Função de limpeza de linha
string limpa(char* linha) {
    string ans = "";
    for(int i = 0; i < strlen(linha); i++) {
        pii dupla = mkp(num linha[i], num linha[i+1]);
        if(acentos.count(dupla)) {
            ans += acentos[dupla];
            i++;
        } else {
            ans += linha[i];
        }
    }
    return ans;
}