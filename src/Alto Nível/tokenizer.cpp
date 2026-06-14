#include <iostream>
#include <vector>
#include <map> 
#include <algorithm>
using namespace std;


#define name_file "./../../texts/noites_brancas_tratado.txt"
#define endl "\n"
#define A (int) 'A'
#define a (int) 'a'

void tokenizer(char *line, vector<string> *tokens);
bool isSplit(char *c);
bool isLetterUpper(char *c);
bool isLetterLow(char *c);
int letterLow(char *c);

int main(){

    FILE* file_text = fopen(name_file, "r");
    map<string, int> frequency;

    // Gerar um map com as frequencias de cada palavra
    if(file_text != nullptr){
        char line[1024];

        while(fgets(line, 1024, file_text))
        {
            vector<string> tokens;
            tokenizer(line, &tokens);

            for(string word: tokens)
            {
                frequency[word]++;
            }
        }

        // Gerar um vector com os pair contidos no map
        vector<pair<string, int>> words(frequency.begin(), frequency.end());

        // Ordena pela frequencia 
        sort(words.begin(), words.end(), 
            [](pair<string, int> item1, pair<string, int> item2){
            if(item1.second != item2.second) return item1.second > item2.second;
            return item1.first < item2.first;
        });

        //Mostra resultados 
        cout << "Palavra ----> Frequência" << endl << endl;
        for(pair<string, int> item: words)
        {
            cout << item.first << " ----> " << item.second << endl;
        }

    }
    else{
        cout << "Não foi possivel abrir o arquivo." << endl;
    }

    return 0;
}

// Recebe uma frase e gera os tokens correspondentes no vector 
void tokenizer(char *line, vector<string> *tokens)
{
    char character;
    int index = 0;
    string word = ""; 

    do{
        character = *(line + index);

        if(isLetterLow(&character))
        {
            word += (int) character;
        }
        else if (isLetterUpper(&character))
        {
            word += letterLow(&character);
        }
        else if(isSplit(&character) && word != ""){
            tokens->push_back(word);
            word = "";
        }

        index++;
    }while(character != '\0');
}

// Verifica se chegou no fim de uma palavra
bool isSplit(char *c)
{
    return !(isLetterLow(c) || isLetterUpper(c));
}

// Verifica se é uma letra maiuscula 
bool isLetterUpper(char *c)
{
    return (*c >= A && *c <= (A + 26));
}

// Verifica se é uma letra minuscula
bool isLetterLow(char *c)
{
    return (*c >= a && *c <= (a + 26));
}

// Transforma uma letra maiusca em minuscula 
int letterLow(char *c)
{
    return ((int) *c) + (a - A);
}