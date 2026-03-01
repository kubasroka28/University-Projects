#include "beneficjent.h"
#include <stdio.h>

// --------------FUNKCJE--------------

struct Osoba*   nowa_osoba(char* imie, uint8_t wiek)
{
    struct Osoba* stworzona_osoba = (struct Osoba*) calloc(1,sizeof(struct Osoba));
    if(stworzona_osoba == NULL) return NULL;

    //przypisywanie imienia
    stworzona_osoba->imie = (char*) malloc(strlen(imie)+1); //+1 dla '\0'
    if(stworzona_osoba->imie == NULL) return NULL;
    strcpy(stworzona_osoba->imie, imie);//kopiowanie imienia z zmiennej imie do nowo przypisanej pamieci

    //przypisywanie wieku
    stworzona_osoba->wiek = wiek;// czyli (*stworzona_osoba).imie

    return stworzona_osoba;
}

void	usun_osobe(struct Osoba* osoba)
{
    free(osoba->imie);
    free(osoba);
}

void	zmien_imie(struct Osoba* osoba, char* imie)
{
    char* temp = (char*) realloc(osoba->imie,(strlen(imie)+1));
    if(temp!=NULL)
    {
        osoba->imie=temp;
        strcpy(osoba->imie, imie);
    }
}

void	zmien_wiek(struct Osoba* osoba, uint8_t wiek)
{
    osoba->wiek = wiek;
}

void	dodaj_zasluge(struct Osoba* osoba)
{
    osoba->zaslugi += 1;
}

void    dodaj_szelmostwo(struct Osoba* osoba)
{
    osoba->szelmostwa += 1;
}

void	ustaw_statystyki(struct Osoba* osoba, unsigned int zaslugi, unsigned int szelmostwa)
{
    osoba->zaslugi = zaslugi;
    osoba->szelmostwa = szelmostwa;
}

int	    czy_dostanie_prezent(struct Osoba* osoba)
{
    if( (osoba->zaslugi > osoba->szelmostwa) || (osoba->wiek < (uint8_t)4) ) return 1;
    else return 0;
}

void	wypisz_info(struct Osoba* osoba)
{
    printf("Imie to: ");
    puts(osoba->imie);

    printf("Wiek to: %d\n",osoba->wiek);

    printf("Liczba zaslug to: %d\n",osoba->zaslugi);

    printf("Liczba szelmostw to: %d\n",osoba->szelmostwa);
}

int	    komparator(struct Osoba* os1, struct Osoba* os2)
{
    unsigned int roznica_zasl_i_szelm = (os1->zaslugi - os1->szelmostwa) - (os2->zaslugi - os2->szelmostwa);
    uint8_t roznica_wieku = os1->wiek - os2->wiek;

    if(roznica_zasl_i_szelm>0) return -1;
    else if (roznica_zasl_i_szelm<0) return 1;
    else if(roznica_wieku>0) return 1;
    else if(roznica_wieku<0) return -1;
    else return 0;
}
