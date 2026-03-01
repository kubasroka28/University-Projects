#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "beneficjent_zad2.h"

#define MAKS_DLUGOSC_WIERSZA 100


//Funkcja szuka indeksu w liscie osob pod ktorym jest osoba o szukanym indeksie
int szukaj_indeks(struct Osoba** Lista_osob, unsigned int szukany_indeks, int liczba_wszystkich_osob)
{
    for(unsigned int i=0; i<(unsigned int)liczba_wszystkich_osob; i++)
    {
        if(Lista_osob[i]->indeks == szukany_indeks) return i;
    }
    return -1;
}

int main()
{
	struct Osoba** Lista_osob = (struct Osoba**) calloc(1, sizeof(struct Osoba*));
	if(Lista_osob == NULL) return NULL;
	int liczba_wszystkich_osob=0;

	char* instrukcje="0 - wyswietl krotka instrukcje obslugi\n\
1 N - wczytaj dane o N osobach, ktore musza wtedy byc podane w N kolejnych liniach, zawierajacych na poczatku wiek, zaslugi i szelmostwa (liczby nieujemne), a potem imie\n\
2 - posortuj dane uzywajac funkcji komparator; mozesz uzyc qsort ze stdlib.h albo napisac ktore z prostych sortowan znanych z WDI\n\
3 - wypisz dane\n\
4 i w - zmien wiek osoby o indeksie i na wartosc w\n\
5 i n - zmien imie osoby o indeksie i na wartosc n\n\
6 i - dodaj zasluge osobie o indeksie i\n\
7 i -dodaj szelmostwo osobie o indeksie i\n\
8 i z s - ustaw statystyki osobie o indeksie i na z (zaslugi) i s (szelmostwa)\n\
9 i - wypisz informacje o osobie o indeksie i\n\
Indeksy osob sa numerowane od 0.\n";

	char wejscie_uzytkownika[MAKS_DLUGOSC_WIERSZA];
	unsigned long numer_instrukcji;
	char* tekst_instrukcji;//to co jest po numerze instrukcji


	while(fgets(wejscie_uzytkownika, MAKS_DLUGOSC_WIERSZA, stdin) != EOF)
	{
        wejscie_uzytkownika[strcspn(wejscie_uzytkownika, "\n")] = '\0';

        numer_instrukcji = strtoul(wejscie_uzytkownika,&tekst_instrukcji,10);
        if(tekst_instrukcji == wejscie_uzytkownika)
        {
                puts("Nie podano numeru instrukcji");
                continue;
        }

        if(numer_instrukcji==0)
        {
            puts(instrukcje);
        }

        if(numer_instrukcji==1)
        {
            //Deklarowanie zmiennych na informacje o nowych osobach
            char dane_o_N_osobach[MAKS_DLUGOSC_WIERSZA];
            uint8_t wiek_nowej_osoby;
            unsigned int zaslugi_nowej_osoby;
            unsigned int szelmostwa_nowej_osoby;
            char* imie_nowej_osoby;

            //Liczenie ile jest nowych osob i ile jest lacznie osob
            int liczba_nowych_osob = atoi(tekst_instrukcji);
            liczba_wszystkich_osob+=liczba_nowych_osob;
            //Realokowanie pamieci dla nowych osob
            struct Osoba** tymczasowa_Lista_osob = (struct Osoba**) realloc(Lista_osob , liczba_wszystkich_osob*sizeof(struct Osoba));
            if(tymczasowa_Lista_osob == NULL)
            {
                printf("Nie udalo sie przydzielic pamieci na nowe osoby.\nSprobuj jeszcze raz.\n");
                continue;
            }
            else Lista_osob=tymczasowa_Lista_osob;

            //Wczytywanie kolejnych wierszow z danymi o nowych osobach
            for(int i=0; i < liczba_nowych_osob; i++)
            {
                //Wczytanie jednego wiersza z danymi i usuniecie znaku zlamania wiersza
                fgets(dane_o_N_osobach, MAKS_DLUGOSC_WIERSZA, stdin);
                dane_o_N_osobach[strcspn(dane_o_N_osobach, "\n")] = '\0';

                //Wyciaganie po kolei wszystkich danych z dane_o_N_osobach i wpiysywanie ich do zmiennych
                wiek_nowej_osoby = strtoul(dane_o_N_osobach,&imie_nowej_osoby,10);
                zaslugi_nowej_osoby = strtoul(imie_nowej_osoby,&imie_nowej_osoby,10);
                szelmostwa_nowej_osoby = strtoul(imie_nowej_osoby,&imie_nowej_osoby,10);
                //Pozbywanie sie spacji miedzy liczba szelmostw a imieniem
                while (*imie_nowej_osoby == ' ') imie_nowej_osoby++;


                //Tworzenie nowej osoby z podanymi danymi
                Lista_osob[liczba_wszystkich_osob - liczba_nowych_osob + i] = nowa_osoba(imie_nowej_osoby, wiek_nowej_osoby);
                ustaw_statystyki(Lista_osob[liczba_wszystkich_osob - liczba_nowych_osob + i],zaslugi_nowej_osoby,szelmostwa_nowej_osoby);
            }
            putchar('\n');
        }

        if(numer_instrukcji==2)
        {

            for(int i=0; i<liczba_wszystkich_osob; i++)
            {
                //unsigned int indeks_najlepszej_osoby=i;
                for(int j=i+1; j<liczba_wszystkich_osob; j++)
                {
                    if(komparator(Lista_osob[i],Lista_osob[j]) == 1)
                    {
                        struct Osoba* tymczasowa_osoba = Lista_osob[j];
                        Lista_osob[j] = Lista_osob[i];
                        Lista_osob[i] = tymczasowa_osoba;
                    }

                        //indeks_najlepszej_osoby=j;
                }
                //struct Osoba* tymczasowa_osoba = Lista_osob[j];
                //Lista_osob[j] = Lista_osob[indeks_najlepszej_osoby];
                //Lista_osob[indeks_najlepszej_osoby] = tymczasowa_osoba;
            }
        }

        if(numer_instrukcji==3)
        {
            printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
            printf("Oto dane o wszystkich osobach\n");
            printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
            for(int i=0; i<liczba_wszystkich_osob; i++)
            {
                printf("Osoba z indeksem %d:\n",Lista_osob[i]->indeks);
                wypisz_info(Lista_osob[i]);
                if(i+1<liczba_wszystkich_osob) putchar('\n');
            }
            printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        }

        if(numer_instrukcji==4)
        {
            unsigned int indeks_4 = strtoul(tekst_instrukcji, &tekst_instrukcji, 10);
            indeks_4=szukaj_indeks(Lista_osob, indeks_4, liczba_wszystkich_osob);

            if(indeks_4>=liczba_wszystkich_osob)
            {
                printf("Nie ma osoby o podanym indeksie\n\n");
                continue;
            }

            int nowy_wiek_dla_indeks_4 = atoi(tekst_instrukcji);

            if(nowy_wiek_dla_indeks_4<0)
            {
                printf("Wiek nie moze byc mniejszy od zera\n\n");
                continue;
            }
            if(nowy_wiek_dla_indeks_4>255)
            {
                printf("Wiek nie moze byc wiekszy od 255\n\n");
                continue;
            }

            zmien_wiek(Lista_osob[indeks_4], nowy_wiek_dla_indeks_4);
            putchar('\n');
        }

        if(numer_instrukcji==5)
        {
            unsigned int indeks_5 = strtoul(tekst_instrukcji, &tekst_instrukcji, 10);
            indeks_5=szukaj_indeks(Lista_osob, indeks_5, liczba_wszystkich_osob);

            if(indeks_5>=liczba_wszystkich_osob)
            {
                printf("Nie ma osoby o podanym indeksie\n\n");
                continue;
            }

            //Pozbywanie sie spacji miedzy indeksem a imieniem
            while (*tekst_instrukcji == ' ') tekst_instrukcji++;

            zmien_imie(Lista_osob[indeks_5], tekst_instrukcji);
            putchar('\n');
        }

        if(numer_instrukcji==6)
        {
            unsigned int indeks_6 = atoi(tekst_instrukcji);
            indeks_6=szukaj_indeks(Lista_osob, indeks_6, liczba_wszystkich_osob);

            if(indeks_6>=liczba_wszystkich_osob)
            {
                printf("Nie ma osoby o podanym indeksie\n\n");
                continue;
            }

            dodaj_zasluge(Lista_osob[indeks_6]);
            putchar('\n');
        }

        if(numer_instrukcji==7)
        {
            unsigned int indeks_7 = atoi(tekst_instrukcji);
            indeks_7=szukaj_indeks(Lista_osob, indeks_7, liczba_wszystkich_osob);

            if(indeks_7>=liczba_wszystkich_osob)
            {
                printf("Nie ma osoby o podanym indeksie\n\n");
                continue;
            }

            dodaj_szelmostwo(Lista_osob[indeks_7]);
            putchar('\n');
        }

        if(numer_instrukcji==8)
        {
            unsigned int indeks_8 = strtoul(tekst_instrukcji, &tekst_instrukcji, 10);
            indeks_8=szukaj_indeks(Lista_osob, indeks_8, liczba_wszystkich_osob);

            if(indeks_8>=liczba_wszystkich_osob)
            {
                printf("Nie ma osoby o podanym indeksie\n\n");
                continue;
            }

            unsigned int nowa_liczba_zaslug_dla_indeks_8 = strtoul(tekst_instrukcji, &tekst_instrukcji, 10);
            if(nowa_liczba_zaslug_dla_indeks_8<0)
            {
                printf("Liczba zaslug nie moze byc mniejsza niz zero\n\n");
                continue;
            }
            unsigned int nowa_liczba_szelmostw_dla_indeks_8 = strtoul(tekst_instrukcji, &tekst_instrukcji, 10);
            if(nowa_liczba_szelmostw_dla_indeks_8<0)
            {
                printf("Liczba szelmostw nie moze byc mniejsza niz zero\n\n");
                continue;
            }
            ustaw_statystyki(Lista_osob[indeks_8],nowa_liczba_zaslug_dla_indeks_8,nowa_liczba_szelmostw_dla_indeks_8);
            putchar('\n');
        }

        if(numer_instrukcji==9)
        {
            unsigned int indeks_9 = atoi(tekst_instrukcji);
            indeks_9=szukaj_indeks(Lista_osob, indeks_9, liczba_wszystkich_osob);

            if(indeks_9>=liczba_wszystkich_osob)
            {
                printf("Nie ma osoby o podanym indeksie\n");
                continue;
            }

            printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
            printf("Osoba z indeksem %d:\n",Lista_osob[indeks_9]->indeks);
            wypisz_info(Lista_osob[indeks_9]);
            printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n");
        }
	}

	for(int i=0; i<liczba_wszystkich_osob; i++)
    {
        free(Lista_osob[i]);
    }
    free(Lista_osob);

    return 0;
}

