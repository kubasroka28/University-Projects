#include <stdio.h>

int main()
{
    int n=0, m=0, d=0;
    scanf("%d%d%d", &n, &m, &d);

    int Kaktusy[n][m];
    for(int i=0; i<n; i++) //wczytywanie wysokosci kaktusow
    {
        for(int j=0; j<m; j++)
        {
            scanf("%d", &Kaktusy[i][j]);
        }
    }

    int WysokoscKaktusow=0; //suma wysokosci wszystkich kaktusow
    int MaksWysokoscKaktusow=0; //najwieksza suma wysokosci wszystkich kaktusow kiedykolwiek
    for(int i=0; i<d; i++)
    {
        WysokoscKaktusow=0;
        for(int j=0; j<n; j++)//petla ktora liczy sume wysokosci wszystkich kaktusow
        {
            for(int k=0; k<m; k++)
            {
                WysokoscKaktusow+=Kaktusy[j][k];
            }
        }
        if(WysokoscKaktusow>MaksWysokoscKaktusow) MaksWysokoscKaktusow=WysokoscKaktusow;


        for(int j=0; j<(i%n)+1; j++)//petla ktora zmienia wysokosc kaktusow
        {
            for(int k=0; k<m; k++)
            {
                if(Kaktusy[j][k]%2==1) Kaktusy[j][k]=3*Kaktusy[j][k]+1;
                else Kaktusy[j][k]=Kaktusy[j][k]/2;
            }
        }
    }

    WysokoscKaktusow=0;
    for(int j=0; j<n; j++)//petla ktora liczy sume wysokosci wszystkich kaktusow po ostatnim dniu
    {
        for(int k=0; k<m; k++)
        {
            WysokoscKaktusow+=Kaktusy[j][k];
        }
    }
    if(WysokoscKaktusow>MaksWysokoscKaktusow) MaksWysokoscKaktusow=WysokoscKaktusow;

    printf("%d", MaksWysokoscKaktusow);

    return 0;
}
