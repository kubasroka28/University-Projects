#include <stdio.h>
#include <math.h>

//wartosci funkcji nie moga przekraczac 40
void Generowanie_wielomianu(int n)//wersja z dowolnym wielomianem (ktora oczywiscie nie przestrzega warunku o wartosciach funkcji)
{
    int stopien=0;
    printf("Podaj stopien wielomianu, ktory chcesz wygenerowac:");
    scanf("%d",&stopien);
    int wspolczynniki[stopien+1];
    printf("Podaj wspolczynniki wielomianu od tego przy najwiekszej potedze:");
    for(int i=0; i<=stopien; i++)
    {
        scanf("%d",&wspolczynniki[i]);
    }
    printf("%d; ",n);
    for(int i=0; i<n; i++)//wartosc funkcji dla danego i
    {
        int wartosc=0;
        int potega=1;
        for(int j=0; j<=stopien; j++)
        {
            wartosc+=wspolczynniki[stopien-j]*potega;
            potega*=i;
        }
        printf("%f ", wartosc);
    }
}

void Generowanie_funkcji(int n)//ciekawa funkcja floor((sinx * x) / 4)
{
    for(int i=0; i<n; i++)//wartosc funkcji dla danego i
    {
        double wartosc=0;
        wartosc=(sin(i)*i)/4;
        printf("%d ", wartosc);
    }
}

int main()
{
     int n=80;
     Generowanie_funkcji(n);

     return 0;
}
