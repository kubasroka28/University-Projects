#include <stdio.h>
#include <stdbool.h>

/* Wypisz wszystkie wiersze zawierajace podany wzorzec. Tekst jest zadany
 * na standardowym wejściu, a wzorzec (dowolny ciąg znaków) jest podany jako
 * parametrem wywołania programu. Na standardowe wyjście kopiowane są
 * wiersze zawierające podany wzorzec. */

#define MAKS_DLUGOSC_WIERSZA 1000

static bool wystapil(char wzor[], char buf[], int pozycja)
{
    int i,j;

    for (i=0, j=pozycja; wzor[i] == buf[j]; ++i, ++j)
        if (wzor[i] == '\0') return true;
    return (wzor[i]=='\0');
}

static int dlugosc(char tekst[])
{
    int i=0;

    while (tekst[i] != '\0') ++i;
    return i;
}

int main(int argc, char *argv[])
{
    char bufor[MAKS_DLUGOSC_WIERSZA];
    int dlugosc_wzorca,dlugosc_wiersza;

    if (argc <= 1)
    {
        printf("Prawidlowe wywolanie programu:\n\t%s wzorzec\n",argv[0]);
        return 1;
    }
    dlugosc_wzorca=dlugosc(argv[1]);
    while (fgets(bufor,sizeof(bufor),stdin) != NULL)
    {
        dlugosc_wiersza=dlugosc(bufor);
        for (int i=dlugosc_wiersza-dlugosc_wzorca; i >= 0; --i) // nieoptymalnie
            if (wystapil(argv[1],bufor,i))
            {
                fputs(bufor,stdout);
                break;
            }
    }
    return 0;
}
