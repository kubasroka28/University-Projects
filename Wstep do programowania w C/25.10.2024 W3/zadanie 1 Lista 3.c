#include <stdio.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char *argv[])
{
    if (argc <= 1) //sprawdzenie czy zostaly wypisane jakiekolwiek argumenty dla programu
    {
        printf("Prawidlowe wywolanie programu:\n\t%s wzorzec\n",argv[0]);
        return 1;
    }

    int DlugoscNapisu=0;
    for(int i=1; i<argc; i++) //petla liczaca dlugosc napisu
    {
        DlugoscNapisu+=strlen(argv[i]);
    }

    int Pozycja=0;
    for(int i=0; i<DlugoscNapisu; i++) //petla wypisujaca fale meksykanska
    {
        Pozycja=0;
        for(int j=1; j<argc; j++) //wypisywanie poszczegolnych wierszy
        {
            for(int k=0; k<strlen(argv[j]); k++) //wypisywanie poszczegolnych slow i sprawdzanie czy wypisac wielka czy mala litere
            {
                if(i==Pozycja) putchar(toupper(argv[j][k]));
                else putchar(tolower(argv[j][k]));
                Pozycja++;
            }
            putchar(' ');
        }
        putchar('\n');
    }

    return 0;
}
