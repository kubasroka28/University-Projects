#include <stdio.h>
#include <ctype.h>
#include <string.h>

void rozklad_na_monety(int x)
{
    int monety[9]={};


    for(int i=2; i>-1; i--)
    {
        int rzad_wielkosci=1;
        for(int j=0; j<i; j++)
        {
            rzad_wielkosci*=10;
        }
        int pom=3*(2-i);//sprawdzanie do indeksu czy to pelne zlotowki/dziesiatki groszy/grosze
        //sprawdzanie ile razy kolejno 5,2,1 w odpowiednim rzedzie wielkosci miesza sie w kwocie i zapisywanie tego do tablicy
        //nastepnie odejmowanie tego za pomoco modulo
        monety[0+pom]=x/(5*rzad_wielkosci);
        x=x%(5*rzad_wielkosci);
        printf("%dx%d\n",monety[0+pom],5*rzad_wielkosci);


        monety[1+pom]=x/(2*rzad_wielkosci);
        x=x%(2*rzad_wielkosci);

        monety[2+pom]=x/(1*rzad_wielkosci);
        x=x%(1*rzad_wielkosci);
    }

    for(int i=0; i<9; i++)
    {
        printf("%d\n",monety[i]);
    }
}

int main(int argc, char *argv[])
{
    if (argc <= 1) //sprawdzenie czy zostaly wypisane jakiekolwiek argumenty dla programu
    {
        printf("Podaj liczbe w parametrach wywolania funkcji");
        return 1;
    }

    //int liczba = atoi(&argv[1][0]); // konwersja pierwszego argumentu na liczbe calkowita //okazuje sie ze to nie dziala, atoi oczekuje calego stringa a nie char
    int test = argv[1][0]-'0';

    int liczba=0;


    //int rzad_wielkosci=1; //jednak nie potrzebne
    int ile_liczb_po_przecinku=0;
    int czesc_dziesietna=0;
    int i=0;
    /*while(i<strlen(argv[1])) //while((argv[1][i])!='\0')
    {

        if('0'<=argv[1][i] && argv[1][i]<='9')//jezeli wczytujemy cyfre to dodajemy ja do naszej liczby
        {
            liczba=liczba*rzad_wielkosci+(argv[1][i]-'0');//dodajemy cyfre korzystajac z wartosci ASCII i reszte liczby zwiekszamy o rzad wielkosci
            rzad_wielkosci*=10;
            ile_liczb_po_przecinku++;//najpierw sztucznie liczymy ile liczb po przecinku
        }
        else if(argv[1][i]=='.' || argv[1][i]==',') ile_liczb_po_przecinku=0;
        else {printf("BLAD"); return 0;}


        i++;
    }*/

    while((argv[1][i])!='\0')
    {
        if('0'<=argv[1][i] && argv[1][i]<='9')//jezeli wczytujemy cyfre to dodajemy ja do naszej liczby
        {
            liczba=liczba*10+(argv[1][i]-'0');//dodajemy cyfre korzystajac z wartosci ASCII i reszte liczby zwiekszamy o rzad wielkosci
            if(czesc_dziesietna==1) ile_liczb_po_przecinku++;
        }
        else if(argv[1][i]=='.' || argv[1][i]==',') czesc_dziesietna=1;
        else {printf("BLAD"); return 0;}

        i++;
    }
    if(ile_liczb_po_przecinku>2) {printf("BLAD"); return 0;}
    else if (ile_liczb_po_przecinku==1) liczba*=10;
    else if (ile_liczb_po_przecinku==0) liczba*=100;
//teraz juz na pewno mam poprawna liczbe i reprezentuja ona kwote w groszach

rozklad_na_monety(liczba);

    //printf("Liczba to:%d\nilosc liczb po przecinku to:%d\n", liczba, ile_liczb_po_przecinku);
    //if (argv[1]<0 || argv[0])

    return 0;
}
