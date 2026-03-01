#include <stdio.h>
#include <math.h>

void Generowanie_wielomianu(int n)//wersja z dowolnym wielomianem (ktora oczywiscie nie przestrzega warunku o wartosciach funkcji)
{
    int stopien=0;
    printf("Podaj stopien wielomianu, ktory chcesz wygenerowac:");
    scanf("%d",&stopien);//wczytanie stopnia wielomianu

    int wspolczynniki[stopien+1];
    printf("Podaj wspolczynniki wielomianu od tego przy najwiekszej potedze:");
    for(int i=0; i<=stopien; i++)//wczytanie wspolczynnikow
    {
        scanf("%d",&wspolczynniki[i]);
    }

    printf("%d; ",n);//wypisanie n
    for(int i=0; i<n; i++)//wypisanie wartosci funkji dla argumentu i
    {
        int wartosc=0;
        int i_do_potegi=1;
        for(int j=0; j<=stopien; j++)//doliczanie do wartosci kolejnych iloczynow wielomianu
        {
            wartosc+=wspolczynniki[stopien-j]*i_do_potegi;
            i_do_potegi*=i;
        }
        printf("%d ", wartosc);
    }
}

void Generowanie_funkcji_zsin(int n)//ciekawa funkcja floor((sinx * x) / 4)
{
    printf("%d; ",n);
    for(int i=0; i<n; i++)//wartosc funkcji dla danego i
    {
        int wartosc=0;
        //wartosc=(sin(i)*i)/4;
        wartosc=(int)floor((sin(i)*i)/4);
        printf("%d ", wartosc);
    }
}

int main()
{
    int n=80;
    //Generowanie_funkcji_zsin(n);
    Generowanie_wielomianu(n);
    return 0;
}
