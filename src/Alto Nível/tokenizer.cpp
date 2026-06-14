#include <iostream>
#include <vector>
#include <map> 
#include <algorithm>
using namespace std;


#define name_file "./../../noites_brancas_tratado.txt"
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

    char line[1024];
    int next;
    map<string, int> frequency;

    if(file_text != nullptr){
        while(fgets(line, 1024, file_text))
        {
            vector<string> tokens;
            tokenizer(line, &tokens);

            cout << "Tokens gerados: " << endl;
            for(string word: tokens)
            {
                frequency[word]++;
            }

            if(next == 0)
            {
                break;
            }
        }
    }

    vector<pair<string, int>> words;

    for(pair<string, int> item: frequency)
    {
        words.push_back(item);
    }

    sort(words.begin(), words.end(), 
        [](pair<string, int> item1, pair<string, int> item2){
        return item1.second < item2.second;
    });

    for(pair<string, int> item: words)
    {
        cout << "Palavra: " << item.first << " - Frequencia: " << item.second << endl;
    }

    return 0;
}

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
        else if(isSplit(&character))
        {
            tokens->push_back(word);
            word = "";
        }
        index++;
    }while(character != '\0');
}

bool isSplit(char *c)
{
    return (*c == ' ') || (*c == '\0');
}

bool isLetterUpper(char *c)
{
    return (*c >= A && *c <= (A + 26));
}

bool isLetterLow(char *c)
{
    return (*c >= a && *c <= (a + 26));
}

int letterLow(char *c)
{
    return ((int) *c) + (a - A);
}