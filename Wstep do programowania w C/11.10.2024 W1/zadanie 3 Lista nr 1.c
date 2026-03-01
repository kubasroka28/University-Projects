#include <stdio.h>

int main()
{
    int n;

    //printf("Podaj liczbe n nie wieksza od miliona. Nastepnie wpisz ciag od dlugosci n-1 skladajacy się z 1 i -1 oddzielonych spacjami\n");
    scanf("%d", &n);
    //if(n>1000000) {printf("Podales bledne n, ktore jest wieksze od 1000000"); return 0;}

    int Zaleznosci[n-1]; //tablica na zaleznosci 1 i -1
    int Pozycja=0, MinimalnaPozycja=0; //zmienne dzieki ktorym bedzie wiadomo od jakiej liczby zaczac ciag

    for(int i=0; i<n-1; i++) //petla zczytujaca z wejscia zaleznosci i przy okazji na biezaco obliczajaca pozycje i minimalna pozycje
    {
        scanf("%d", &Zaleznosci[i]);
        Pozycja+=Zaleznosci[i];
        if(Pozycja<MinimalnaPozycja) MinimalnaPozycja=Pozycja;
    }

    int Ciag[n];
    Ciag[0]=1-MinimalnaPozycja; //ustawienie odpowiedniego elementu pierwszego
    printf("%d ",Ciag[0]);
    for(int i=1; i<n; i++) //petla ktora na biezaco oblicza kolejne elementy ciagu a potem je wypisuje
    {
        Ciag[i]=Ciag[i-1]+Zaleznosci[i-1];
        printf("%d ",Ciag[i]);
    }
    return 0;
}
