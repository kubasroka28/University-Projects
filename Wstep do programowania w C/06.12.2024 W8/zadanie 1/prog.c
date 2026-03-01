#include <stdio.h>
#include "beneficjent.h"

int main()
{
    struct Osoba* osoba1 = nowa_osoba("Radek", 23);

    wypisz_info(osoba1);

    zmien_imie(osoba1, "Rafal");
    zmien_wiek(osoba1, 20);
    dodaj_zasluge(osoba1);
    dodaj_zasluge(osoba1);
    dodaj_szelmostwo(osoba1);
    fputs(osoba1->imie, stdout);
    czy_dostanie_prezent(osoba1) ? : printf(" nie ");
    printf(" dostanie ");
    czy_dostanie_prezent(osoba1) ? printf("prezent\n") : printf("prezentu\n");

    struct Osoba* osoba2 = nowa_osoba("Marcin", 13);
    ustaw_statystyki(osoba2, 2, 1);

    if(komparator(osoba1, osoba2)==-1)
    {
        printf("Prezent powinien dostac ");
        puts(osoba1->imie);
    }
    else if(komparator(osoba1, osoba2)==1)
    {
        printf("Prezent powinien dostac ");
        puts(osoba2->imie);
    }
    else printf("Jest remis miedzy beneficjentami o prezent\n");

    zmien_wiek(osoba2, 3);
    ustaw_statystyki(osoba2, 2, 23);

    printf("czy osoba2 powinna dostac prezent? Odp to: ");
    czy_dostanie_prezent(osoba2) ? printf("tak") : printf("nie");

    usun_osobe(osoba1);

    return 0;
}
