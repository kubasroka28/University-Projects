#include <stdio.h>
int licznik=0;

int IleJestTrojkatowPitagorejskichDlaDanegoM(int M)
{
    int x=0; //zmienna mowi ile jest trojkatow pitagorejskich dla danego M

    /*for(int a=1; a<M; a++)   //pierwotna wersja z szescienna zlozonoscia
    {
        for(int b=1; b<M; b++)
        {
            for(int c=1; c<M; c++)
            {
                if((a>b) && (a>c) && (b*b+c*c==a*a) && (a+b+c==M)) x++;
                if((b>a) && (b>c) && (a*a+c*c==b*b) && (a+b+c==M)) x++;
                if((c>b) && (c>a) && (a*a+b*b==c*c) && (a+b+c==M)) x++;
            }
        }
    }*/

    /*for(int a=(M+2)/3; a<=M/2; a++) //wersja taty
    {
        for(int b=(M-a+1)/2; b<=a; b++)
        {
            licznik++;
            int c=M-a-b;
            if(c>0)
            {
                if((a>b) && (a>c) && (b*b+c*c==a*a)) x++;
                if((b>a) && (b>c) && (a*a+c*c==b*b)) x++;
                if((c>b) && (c>a) && (a*a+b*b==c*c)) x++;
            }
        }
    }*/

    for(int a=0; a<M; a++)
    {
        for(int b=0; b<M; b++)
        {
            int c=M-a-b;
            if(c>0)
            {
                if((a>b) && (a>c) && (b*b+c*c==a*a)) x++;
                if((b>a) && (b>c) && (a*a+c*c==b*b)) x++;
                if((c>b) && (c>a) && (a*a+b*b==c*c)) x++;
            }
        }
    }

    x=x/6; //trzeba podzielic wynik przez liczbe permutacji trzech zmiennych czyli 3!=6

    return x;
}
/* uwagi taty:
nie trzeba sprawdzać czy (a+b+c==M), bo c=M-a-b
można inaczej zorganizować te pętle, tak, żeby zawsze a>=b>=c>0. Ciekawe pytanie: "ilukrotnie to przyspieszy program?"
można oszczędzić na obliczaniu a*a
if(N<12) program wypisuje komunikat ale i tak leci dalej.

inne ciekawe pytanie: ile razy ten program przechodzi najwewnętrzniejszą pętlę? 1. spróbuj obliczyć; 2. sprawdź dodając licznik.

Podaj liczbe N>=12: 10000
Dla N=10000 maksimum wynosi 20 i osiagane jest dla liczby M=9240
Process returned 0 (0x0)   execution time : 813.099 s

Podaj liczbe N>=12: 1000
Dla N=1000 maksimum wynosi 8 i osiagane jest dla liczby M=840
Process returned 0 (0x0)   execution time : 6.132 s

*/
int main(void)
{
    int N=0, M=0;
    licznik=0;
    printf ("Podaj liczbe N>=12: ");
    scanf ("%d",&N);
    if(N<12) {printf("Podales bledne N, ktore jest <12"); return 0;}

    int Ile=0, MaksIle=0, MaksM=0;

    for(M=3; M<=N; M++)
    {
        Ile=IleJestTrojkatowPitagorejskichDlaDanegoM(M);
        if(MaksIle<Ile)
        {
            MaksIle=Ile;
            MaksM=M;
        }
    }

    printf("Dla N=%d maksimum wynosi %d i osiagane jest dla liczby M=%d\n",N,MaksIle,MaksM);
    printf("%d",licznik);
    return 0;
}
