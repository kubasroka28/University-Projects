//Jakub Sroka 355255 Lista 3 zadanie 3

#include <stdio.h>
#include <limits.h>

int CzyPierwsza(int x)
{
    if(x<2) return 0;
    for(int i=2; i*i<=x; i++)
    {
        if(x%i==0) return 0;
    }
    return 1;
}

int CzyMa3i7(int x)
{
    int CzyMa3=0;
    int CzyMa7=0;

    while(x>0)
    {
        if(x%10==3) CzyMa3=1;
        if(x%10==7) CzyMa7=1;
        x/=10;

        if(CzyMa3==1 && CzyMa7==1) return 1;
    }
    return 0;
}

int CzyPierwszaiCzyMa3i7(int x)
{
    return CzyPierwsza(x) && CzyMa3i7(x);
}

int NajmniejszaWartosc(int Tab[], int DlugoscTablicy, int v)
{
    int min=INT_MAX;

    for(int x=0; x<DlugoscTablicy-1; x++)
    {
        for(int y=x+1; y<DlugoscTablicy; y++)
        {
            int pocz_zakresu=0, kon_zakresu=DlugoscTablicy, srod_zakresu=0, cel=Tab[x]+Tab[y]-v;
            int z=0;

            while(pocz_zakresu<kon_zakresu-1)
            {
                srod_zakresu=(pocz_zakresu+kon_zakresu)/2;
                if(cel>Tab[srod_zakresu]) pocz_zakresu=srod_zakresu;
                else kon_zakresu=srod_zakresu;
            }
            z=pocz_zakresu;
            while(z==x || z==y || Tab[x]+Tab[y]-Tab[z]<v) z-=1;
            if((Tab[x]+Tab[y]-Tab[z])<min && z!=x && z!=y) min=Tab[x]+Tab[y]-Tab[z];


            /*for(int z=0; z<DlugoscTablicy; z++)
            {
                if(z!=x && z!=y)
                {
                    if(Tab[x]+Tab[y]-Tab[z]>v && Tab[x]+Tab[y]-Tab[z]<min) min=Tab[x]+Tab[y]-Tab[z];
                }
                //if(Tab[x]+Tab[y]-Tab[z]>v && Tab[x]+Tab[y]-Tab[z]<min && y!=z && x!=z) min=Tab[x]+Tab[y]-Tab[z];
            }*/
        }
    }
    return min;
}

int Gasienica(int Tab[], int DlugoscTablicy, int v)
{
    int min=INT_MAX;

    for(int z=0; z<DlugoscTablicy; z++)
    {
        int x=0, y=DlugoscTablicy-1;
        int suma=0;
        while(x<y)
        {
            suma=Tab[x]+Tab[y];
            if(suma>Tab[z]+v)
            {
                if(suma-Tab[z]<min && z!=x && z!=y) min=suma-Tab[z];
                y--;
            }
            else x++;
        }
    }
    return min;
}

int main()
{
    int n=0, m=0, v=0;
    scanf("%d%d%d",&n,&m,&v);

    //tutaj sa dwa sposoby jak to zrobic
    //dwie petle dzieki czemu mamy duzo mniejsza tablice, ale dwa razy szukamy te liczby
    //jedna petla ale tablica bedzie miala rozmiar [m-n] i zmarnuje sie duzo pamieci
    int IleTakichLiczb=0;
    for(int i=n; i<=m; i++)//liczenie ile jest tych liczb, aby potem stworzyc tablice tego rozmiaru
    {
        if(CzyPierwszaiCzyMa3i7(i))
        {
            IleTakichLiczb++;
        }
    }
    int Tab[IleTakichLiczb];
    IleTakichLiczb=0;
    for(int i=n; i<=m; i++)
    {
        if(CzyPierwszaiCzyMa3i7(i)==1)
        {
            Tab[IleTakichLiczb]=i;
            IleTakichLiczb++;
        }
    }



    /*for(int i=0; i<IleTakichLiczb; i++)
    {
        printf("%d\n",Tab[i]);
    }*/

    //printf("%d",NajmniejszaWartosc(Tab, IleTakichLiczb, v));
    printf("%d",Gasienica(Tab, IleTakichLiczb, v));
    //NajmniejszaWartosc(Tab, IleTakichLiczb, v);

    return 0;
}
