#include "sortowanie wierszy.h"

#ifdef USE_QSORT
void sortowanie_wierszy(char*** tablica_wierszy, int liczba_wierszy, int (*komparator) (const void*, const void*))
{
    qsort(tablica_wierszy, liczba_wierszy, sizeof(char**), komparator);
    //printf("uzyto qsort\n"); //do przetestowania dzialania flagi
}

#else
// Indeks: 355255
// Reszta z dzielenia przez 3: 1
// Algorytm sortowania: przez wstawianie
void sortowanie_wierszy(char*** tablica_wierszy, int liczba_wierszy, int (*komparator) (const void*, const void*))
{
    for(int i=1; i<liczba_wierszy; i++)
    {
        char** pom = tablica_wierszy[i];
        int j;
        for(j=i-1; j>=0; j--)
        {
            if(komparator(&pom, &tablica_wierszy[j]) < 0) tablica_wierszy[j+1] = tablica_wierszy[j];
            else break;
        }
        tablica_wierszy[j+1] = pom;
    }
    //printf("uzyto insertsort\n"); //do przetestowania dzialania flagi
}

#endif
