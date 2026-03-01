#include <stdio.h>

int IleJestTrojkatowPitagorejskichDlaDanegoM(int M)
{
    int x=0; //zmienna mowi ile jest trojkatow pitagorejskich dla danego M

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

int main(void)
{
    int N=0, M=0;
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

    return 0;
}
