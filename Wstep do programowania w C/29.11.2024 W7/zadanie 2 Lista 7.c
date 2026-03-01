#include <stdio.h>
#include <stdlib.h>

int liczba_dzielnikow(unsigned long n)
{
    int licznik=0;
    int dzielnik=1;

    while(dzielnik*dzielnik<=n)
    {
        if(n%dzielnik==0) licznik+=2;// liczymy dwa dzielniki ktore wystepuja parami d i n/d
        if(dzielnik*dzielnik==n) licznik--;//jezeli to jest pierwiastek to liczymy go tylko raz
        dzielnik++;
    }

    return licznik;
}

int main(int argc, char *argv[])
{
    //sprawdzanie czy zostal podany argument funkcji
    if(argc<=1)
    {
        printf("Za malo argumentow wywolania funkcji");
        return 1;
    }

    //wczytywanie argumentu funkcji do zmiennej unsigned long
    char *endptr;
    unsigned long N=strtoul(argv[1],&endptr,10);
    if(endptr==argv[1])
    {
        printf("Podany argument funkcji nie jest liczba\n");
        return 1;
    }
    if (endptr[0]!='\0')   printf("Argument funkcji zawieral czesc, ktora nie jest liczba: %s\n\n", endptr);

    //szukanie odpowiedzi do zadania
    unsigned long nta_liczba_trojkatna=1;
    int n=1;
    while(liczba_dzielnikow(nta_liczba_trojkatna)<N)
    {
        n++;
        nta_liczba_trojkatna+=n;
    }

    //wypisywanie wyniku
    printf("Najmniejsza liczba trojkatna, ktora ma wiecej niz %lu ",N);
    if(N==1) printf("dzielnik ");
    if(N>=2 && N<=4) printf("dzielniki ");
    if(N==0 || N>4) printf ("dzielnikow ");
    printf("ma indeks %d i jest rowna %lu.\n",n,nta_liczba_trojkatna);

    return 0;
}
