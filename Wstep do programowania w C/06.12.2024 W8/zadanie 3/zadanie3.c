#include <stdio.h>

#define dlugosc_liczb 51 //to ma byc chciana dlugosc liczby +1 (na znak '\0' w stringu)
#define to_ile_cyfr_wypisac 9

int main()
{
    int n=0;
    scanf("%d",&n);

    getchar(); //usuwanie \n
    char liczby[n][dlugosc_liczb];
    for(int i=0; i<n; i++)
    {
        fgets(liczby[i], dlugosc_liczb, stdin);
        getchar();
    }
    /*for(int i=0; i<n; i++)
    {
        puts(liczby[i]);
    }*/

    char wynik[dlugosc_liczb+2];
    for(int i=0; i<dlugosc_liczb+1; i++)
    {
        wynik[i]='a';
    }

    int przeniesienie_do_kolejnego_rzedu_wielkosci=0;
    for(int i=dlugosc_liczb-2; i>=0 || przeniesienie_do_kolejnego_rzedu_wielkosci!=0; i--)
    {
        int suma_na_itym_rzedzie_wielkosci=0;
        if(i>=0)
        {
            for(int j=0; j<n; j++)
            {
                suma_na_itym_rzedzie_wielkosci+=liczby[j][i]-'0';
            }
        }


        //dodawanie wartosci z poprzedniego rzedu
        suma_na_itym_rzedzie_wielkosci+=przeniesienie_do_kolejnego_rzedu_wielkosci;

        //liczenie ile przejdzie do nastepnego rzedu, liczy to rowniez zero
        przeniesienie_do_kolejnego_rzedu_wielkosci=(suma_na_itym_rzedzie_wielkosci-(suma_na_itym_rzedzie_wielkosci%10))/10;

        //ustawianie sumy w danym rzedzie na ta bez przeniesienia (<10)
        suma_na_itym_rzedzie_wielkosci=suma_na_itym_rzedzie_wielkosci-przeniesienie_do_kolejnego_rzedu_wielkosci*10;

        wynik[dlugosc_liczb-2-i]=suma_na_itym_rzedzie_wielkosci+'0';
        //printf("suma na %d rzedzie wielkosci: %d\n",i,suma_na_itym_rzedzie_wielkosci);
    }

//puts(wynik);
    int wypisane=0;
    for(int i=0; wypisane<to_ile_cyfr_wypisac; i++)
    {
       //dlugosc_liczb+1 ostatni indeks w tablicy charow

        if(wynik[dlugosc_liczb-i]!='a')
        {
            putchar(wynik[dlugosc_liczb-i]); //nie zaczynam od ostatniego indeksu wyniku, bo tam jest '\0'
            wypisane++;
        }


    }

    return 0;
}
