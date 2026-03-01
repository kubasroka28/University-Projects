#include <stdio.h>

//program chyba nie dziala, bo dla bardzo duzych liczb n wymaga za duzo pamieci. Musza przeciez wtedy powstac az dwie tablice z np mln elementami

int main()
{
    int n;

    //printf("Podaj liczbe n nie wieksza od miliona. Nastepnie wpisz ciag od dlugosci n-1 skladajacy się z 1 i -1 oddzielonych spacjami\n");
    scanf("%d", &n);
    //2if(n>1000000) {printf("Podales bledne n, ktore jest wieksze od 1000000"); return 0;}

    //int Zaleznosci[n-1]; //tablica na zaleznosci 1 i -1, jej dlugosc to n-1
    int ZaleznosciSkondensowane[n/2]; //tablica na zaleznoci ale mowi ona ile jest jedynek albo -jedynek pod rzad
    int m=0; //Dlugosc tablicy ZaleznosciSkondensowane

    for(int i=0; i<n-1; i++) //petla zczytujaca z wejscia zaleznosci i na biezaca uzupelniajaca ZaleznosciSkondensowane
    {
        scanf("%d", &Zaleznosci[i]);
        if(i==0) ZaleznosciSkondensowane[m]=Zaleznosci[i];
        else
        {
            if(Zaleznosci[i]==Zaleznosci[i-1]) ZaleznosciSkondensowane[m]+=Zaleznosci[i];
            else
            {
                m++;
                ZaleznosciSkondensowane[m]=0;
                ZaleznosciSkondensowane[m]+=Zaleznosci[i];
            }
        }
    }
    if(ZaleznosciSkondensowane[m]>0) ZaleznosciSkondensowane[m+1]=(-1)*ZaleznosciSkondensowane[m];

    /*for(int i=0; i<=m; i++) //testowanie czy ZaleznosciSkondensowane sa dobrze uzupelniane
    {
        printf("%d ", ZaleznosciSkondensowane[i]);
    }*/
    //printf ("\nm=%d, dobrze, ze jest -1\n",m);

    int Ciag[n];
    int Pozycja=0;
    for (int i=0; i<n; i++) //na wszelki wypadek wypelniam tablice ciag zerami
    {
        Ciag[i]=0;
    }


    if(ZaleznosciSkondensowane[0]>0)
    {
        Ciag[Pozycja]=1;
        Pozycja++;
        //printf ("tak, >0");
    }
    else
    {
        Ciag[Pozycja]=((-1)*ZaleznosciSkondensowane[0]+1);
        Pozycja++;
        //printf ("nie, <0");
    }
    //printf ("\n");
    //printf("%d ", Ciag[0]);//testy

    for(int i=0; i<=m; i++) //i<=m jest dobrze
    {
        if(ZaleznosciSkondensowane[i]>0)
        {
            for(int j=0; j<ZaleznosciSkondensowane[i]-1; j++) //w warunku jest -1, poniewaz chce sie zatrzymac i sprawdzic czy musze zrobic duzy skok do gory
            {
                Ciag[Pozycja]=Ciag[Pozycja-1]+1; //tutaj musze dodac
                Pozycja++;
            }

            if(ZaleznosciSkondensowane[i]>=(-1)*ZaleznosciSkondensowane[i+1]) //sprawdzam czy moge zrobic duzy skok
            {
                //tutaj nie moge go zrobic i ide tylko o jeden do gory
                Ciag[Pozycja]=Ciag[Pozycja-1]+1;
                Pozycja++;
            }
            else
            {
                //tutaj moge go zrobic
                Ciag[Pozycja]=Ciag[Pozycja-1]+1+((-1)*ZaleznosciSkondensowane[i+1]-ZaleznosciSkondensowane[i]);
                Pozycja++;
            }
        }
        else //ZaleznosciSkondensowane[i]<0
        {
            if(Ciag[Pozycja-1]+ZaleznosciSkondensowane[i]>1)
            {
                Ciag[Pozycja]=Ciag[Pozycja-1]-1-(ZaleznosciSkondensowane[i-1]+ZaleznosciSkondensowane[i]);
                Pozycja++;
            }
            else
            {
                Ciag[Pozycja]=Ciag[Pozycja-1]-1;
                Pozycja++;
            }






            //Ciag[Pozycja]=Ciag[Pozycja-1]-(ZaleznosciSkondensowane[i]-1); //Ciag[Pozycja]=Ciag[Pozycja-1]-1-(ZaleznosciSkondensowane[i-1]+ZaleznosciSkondensowane[i]);

            for(int j=0; j<((-1)*ZaleznosciSkondensowane[i]-1); j++) //w warunku jest -1, poniewaz zrobilem juz jeden (duzy albo i nie) skok i teraz zostaly mi pozostale
            {
                Ciag[Pozycja]=Ciag[Pozycja-1]-1; //tutaj musze odjac
                Pozycja++;
            }
        }
    }

    for(int i=0; i<n; i++)
    {
        printf("%d ", Ciag[i]);
    }

    return 0;
}
