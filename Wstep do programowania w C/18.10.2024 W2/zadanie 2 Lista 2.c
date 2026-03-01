#include <stdio.h>
/*
Funkcja liczy ile jest liczb nieparzystych w rozkladzie na czynniki pierwsze podanej liczby.
Wykorzystuje do tego program z wykladu, ktory sprawdza dzielniki liczby.
*/
int LiczNiepWRozk(int rozkladana)
{
    int licznik=0; //licznik roznych nieparzystych czynnikow pierwszych w rokladzie
    int dzielnik=0;

    for(dzielnik = 2; dzielnik*dzielnik <= rozkladana; dzielnik = dzielnik+1)
    {
      if(rozkladana%dzielnik==0 && dzielnik%2==1) licznik+=1;
      while(rozkladana % dzielnik == 0)
      {
        rozkladana = rozkladana / dzielnik;
      }
    }
    if(rozkladana%2==1) licznik++;

    return licznik;
}

//Funkcja mowi, ktora z trzech liczb ma najwiecej liczb niep w rozkladzie na czynniki pierwsze
int NajwLiczbNiepWRozk(int x, int y, int z)
{
    int wynik_x=0, wynik_y=0, wynik_z=0; //zmienne mowia ile liczb niep jest w rozkladzie na czynniki pierwsze konkretnej liczby
    wynik_x=LiczNiepWRozk(x);
    wynik_y=LiczNiepWRozk(y);
    wynik_z=LiczNiepWRozk(z);

    if(wynik_x==0 && wynik_y==0 && wynik_z==0) return (-1);

    if(wynik_x>wynik_y && wynik_x>wynik_z) return x;
    else if(wynik_y>wynik_z) return y;
    else return z;

}

int main()
{
    int n=0;
    int x=0;
    int min1=0, min2=0, min3=0;

    printf("Podaj liczbe n>=3:");
    scanf("%d", &n);

    scanf("%d", &x);
    min1=x;
    scanf("%d", &x);
    min2=x;
    scanf("%d", &x);
    min3=x;

    for(int i=0; i<n-3; i++)
    {
        scanf("%d", &x);

        if(x<min1 || x<min2 ||x<min3)
        {
            if(min1>min2 && min1>min3) min1=x;
            else if(min2>min3) min2=x;
            else min3=x;
        }
    }

    printf("Trzy najmniejsze liczby z wypisanych to: %d, %d, %d\n", min1,min2,min3);

    int pom=0;
    pom=NajwLiczbNiepWRozk(min1, min2, min3);

    if(pom==(-1)) printf("Zadna z namniejszych liczb nie ma liczby nieparzystej w swoim rozkladzie");
    else printf("Sposrod tych liczb najwiecej liczb nieparzystch w rozkladzie na czynniki pierwsze ma:%d", pom);

    //printf("Sposrod tych liczb najwiecej liczb nieparzystch w rozkladzie na czynniki pierwsze ma:%d", NajwLiczbNiepWRozk(min1, min2, min3));
    return 0;
}
