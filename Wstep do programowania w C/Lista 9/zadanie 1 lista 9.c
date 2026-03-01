//Jakub Sroka 355255

#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <ctype.h>
#include "sortowanie wierszy.h"

char* readline()
{
    size_t rozmiar_wiersza = 10;
    size_t biezaca_dlugosc_wiersza = 0;
    char* wiersz = (char *) malloc(rozmiar_wiersza*sizeof(char));
    if(wiersz == NULL)
    {
        //printf("Blad alokacji pamieci w funkcji readline dla dlugosci wiersza: %d", biezaca_dlugosc_wiersza);
        return NULL;
    }

    int c;
    while((c = getchar()) != '\n' && c != EOF)
    {
        //sprawdzamy czy trzeba zrealokowac pamiec na dlugi wiersz
        if(biezaca_dlugosc_wiersza + 1 >= rozmiar_wiersza)
        {
            rozmiar_wiersza *= 2;
            char* nowy_wiersz = realloc(wiersz, rozmiar_wiersza * sizeof(char));
            if(nowy_wiersz == NULL)
            {
                free(wiersz);
                return NULL;
            }
            wiersz = nowy_wiersz;
        }
        wiersz[biezaca_dlugosc_wiersza] = (char) c;
        biezaca_dlugosc_wiersza++;
    }
    //przypadek kiedy jestem w linijce z EOF
    if (biezaca_dlugosc_wiersza == 0 && c == EOF) {
        free(wiersz);
        return NULL;
    }

    wiersz[biezaca_dlugosc_wiersza] = '\0';
    return wiersz;
}

char** podzial_wiersza_na_slowa(char* linia_tekstu)
{
    int dlugosc_lini_tekstu = strlen(linia_tekstu);
    char** slowa = (char**) malloc((dlugosc_lini_tekstu + 1) * sizeof(char*) );
    if(slowa == NULL)
    {
        //printf("Blad alokacji pamieci w funkcji dzielacej na slowa dla dlugosci lini tekstu: %d", dlugosc_lini_tekstu);
        return NULL;
    }

    int s=0;    // numer slowa
    int czy_nowe_slowo = 1; // flaga sprawdza czy mamy nowe slowo, czy kolejny graficzny znak
    for(int i=0; i<dlugosc_lini_tekstu; i++)
    {
        if(isgraph(linia_tekstu[i]))
        {
            if(czy_nowe_slowo == 1)
            {
                slowa[s] = &(linia_tekstu[i]);
                s++;
                czy_nowe_slowo = 0;
            }
        }
        else
        {
            linia_tekstu[i] = '\0';
            czy_nowe_slowo = 1;
        }
    }
    slowa[s]=NULL;
    return slowa;
}

int komparator_wierszy(const void* w1,const void* w2)
{
    char** wiersz1 = *(char***)w1;
    char** wiersz2 = *(char***)w2;

    int wynik=0;
    //liczenie slow w obu wierszach
    int liczba_slow_wiersza1=0 , liczba_slow_wiersza2=0;
    for(int i=0; wiersz1[i]; i++) liczba_slow_wiersza1++;
    for(int i=0; wiersz2[i]; i++) liczba_slow_wiersza2++;

    for(int i=liczba_slow_wiersza1-1, j=liczba_slow_wiersza2-1; i>=0 && j>=0; i--, j--)
    {
        wynik = strcmp(wiersz1[i], wiersz2[j]);
        if(wynik != 0) return wynik;
    }

    int roznica_dlugosci = liczba_slow_wiersza2 - liczba_slow_wiersza1;
    if(roznica_dlugosci > 0) return -1;
    else if(roznica_dlugosci <0) return 1;
    return 0;
}

int main()
{
    //!alokowanie pamieci pod wskaznik cale_wejscie
    size_t rozmiar_wejscia = 10;
    size_t liczba_wierszy_na_wejsciu = 0;
    char*** cale_wejscie = (char ***) malloc((rozmiar_wejscia+1) * sizeof(char**));
    if(cale_wejscie == NULL)
    {
        //printf("Blad alokacji pamieci dla calego wejscia");
        return 1;
    }


    //!wczytywanie wejscia
    int c;
    while((c = getchar()) != EOF)
    {
        //dynamiczne alokowanie pamięci dla liczby wierszy
        if(liczba_wierszy_na_wejsciu >= rozmiar_wejscia)
        {
            rozmiar_wejscia *= 2;
            char*** nowe_cale_wejscie = realloc(cale_wejscie, (rozmiar_wejscia+1) * sizeof(char**));
            if(nowe_cale_wejscie == NULL)
            {
                    for(int i=0; i < liczba_wierszy_na_wejsciu; i++){
                        free(cale_wejscie[i][0]);
                        free(cale_wejscie[i]);
                    }
                    free(cale_wejscie);
                    return 1;
            }
            cale_wejscie = nowe_cale_wejscie;
        }

        //wczytywanie wiersza
        ungetc(c, stdin);
        char* wczytywany_wiersz = readline();
        if(wczytywany_wiersz == NULL)
        {
            //printf("wczytywany wiersz to null");
            free(wczytywany_wiersz);
            break;
        }

        //dzielenie wiersza na slowa
        cale_wejscie[liczba_wierszy_na_wejsciu] = podzial_wiersza_na_slowa(wczytywany_wiersz);
        if(cale_wejscie[liczba_wierszy_na_wejsciu] == NULL)
        {
            //printf("podzial na slowa zwrocil null");
            free(cale_wejscie[liczba_wierszy_na_wejsciu][0]);
            free(cale_wejscie[liczba_wierszy_na_wejsciu]);
            break;
        }
        liczba_wierszy_na_wejsciu++;
    }
    cale_wejscie[liczba_wierszy_na_wejsciu] = NULL; //wartownik

    //!sortowanie
    sortowanie_wierszy(cale_wejscie, liczba_wierszy_na_wejsciu, komparator_wierszy);

    //!wypisywanie calego wejscia
    for(int i=0; cale_wejscie[i]; i++)
    {
        for(int j=0; cale_wejscie[i][j]; j++)
        {
            if(j>0) putchar(' ');
            fputs(cale_wejscie[i][j], stdout);
        }
        putchar('\n');
        free(cale_wejscie[i][0]);
        free(cale_wejscie[i]);
    }
    free(cale_wejscie);

    return 0;
}
