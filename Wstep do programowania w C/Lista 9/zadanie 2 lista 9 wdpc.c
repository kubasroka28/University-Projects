//Jakub Sroka 355255

/*Notatki:
zmienna wiek moze byz size_t i wtedy chyba zajmuje mniej miejsca w pamieci
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct elemListy {
    char* imie;
    int wiek;
    struct elemListy* nastepny;
};

typedef struct elemListy* lista;

lista utworzNowaOsobe(char* nowe_imie, int nowy_wiek){
    lista nowaOsoba = malloc(sizeof(struct elemListy));
    nowaOsoba->imie = malloc(strlen(nowe_imie)+1);
    strcpy(nowaOsoba->imie, nowe_imie);
    nowaOsoba->wiek = nowy_wiek;
    nowaOsoba->nastepny = NULL;
    return nowaOsoba;
}

lista dodajOsobeNaKoniecKolejki(lista Lista, lista nowaOsoba){
    if(Lista == NULL) return nowaOsoba;
    lista zapamientanyPoczatekListy = Lista;
    while(Lista->nastepny != NULL) Lista = Lista->nastepny;
    Lista->nastepny = nowaOsoba;
    return zapamientanyPoczatekListy;
}

lista wstawOsobeAprzedOsobeB(lista Lista, lista OsobaA, char* imieOsobyB){
    if(strcmp(Lista->imie, imieOsobyB) == 0){
        OsobaA->nastepny = Lista;
        return OsobaA;
    }

    lista zapamientanyPoczatekListy = Lista;

    while(Lista->nastepny != NULL && strcmp(Lista->nastepny->imie, imieOsobyB) != 0){
        Lista = Lista->nastepny;
    }
    if(Lista->nastepny != NULL){
        lista pom = Lista->nastepny;
        Lista->nastepny = OsobaA;
        OsobaA->nastepny = pom;
    }
    return zapamientanyPoczatekListy;
}

lista usunPierwszaOsobezKolejki(lista Lista){
    lista pom = Lista;
    Lista = Lista->nastepny;
    free(pom->imie);
    free(pom);
    return Lista;
}

lista usunOsobeoDanymImieniuzKolejki(lista Lista, char* imieOsobyUsuwanej){
    if (Lista == NULL) {
    return NULL;
    }

    if(strcmp(Lista->imie, imieOsobyUsuwanej) == 0){
        return usunPierwszaOsobezKolejki(Lista);
    }

    lista zapamientanyPoczatekListy = Lista;

    while(Lista->nastepny != NULL && strcmp(Lista->nastepny->imie, imieOsobyUsuwanej) != 0) Lista = Lista->nastepny;
    if(Lista->nastepny != NULL){
        lista pom = Lista->nastepny;
        Lista->nastepny = Lista->nastepny->nastepny;
        free(pom->imie);
        free(pom);
    }

    return zapamientanyPoczatekListy;
}

void wypiszKolejke(lista Lista){
    //!printf("---Oto kolejka---\n");
    while(Lista != NULL){
        //!printf("Imie: ");
        puts(Lista->imie);
        //!printf("Wiek: %d\n\n",Lista->wiek);
        Lista = Lista->nastepny;
    }
}

int main()
{
    lista Lista_osob_w_kolejce = NULL;
    lista Lista_osob_ktore_weszly_do_klubu = NULL;

    /*!---testy---
    Lista_osob_w_kolejce = utworzNowaOsobe("Adam", 23);

    Lista_osob_w_kolejce = dodajOsobeNaKoniecKolejki(Lista_osob_w_kolejce, utworzNowaOsobe("Marek", 14));
    Lista_osob_w_kolejce = dodajOsobeNaKoniecKolejki(Lista_osob_w_kolejce, utworzNowaOsobe("Tymon", 45));

    wypiszKolejke(Lista_osob_w_kolejce);

    Lista_osob_w_kolejce = wstawOsobeAprzedOsobeB(Lista_osob_w_kolejce, utworzNowaOsobe("Dariusz", 35), "Tymon");
    Lista_osob_w_kolejce = usunPierwszaOsobezKolejki(Lista_osob_w_kolejce);

    wypiszKolejke(Lista_osob_w_kolejce);

    Lista_osob_w_kolejce = dodajOsobeNaKoniecKolejki(Lista_osob_w_kolejce, utworzNowaOsobe("Oskar", 14));
    Lista_osob_w_kolejce = usunOsobeoDanymImieniuzKolejki(Lista_osob_w_kolejce, "Tymon");
    Lista_osob_w_kolejce = usunOsobeoDanymImieniuzKolejki(Lista_osob_w_kolejce, "Dariusz");

    wypiszKolejke(Lista_osob_w_kolejce);
    ---testy---*/

    int liczba_wolnych_miejsc_w_klubie = 0;
    char zdarzenie[2007];
    while(fgets(zdarzenie, 2007, stdin) != NULL){
        //!puts(zdarzenie);
        int czy_Z = 0;
        switch(zdarzenie[0])
        {
        case '+':{
            //Wyciaganie imienia z wejscia
            char imie_nowej_osoby[1001];
            int i;
            for(i = 2; zdarzenie[i] != ' '; i++){
                imie_nowej_osoby[i-2] = zdarzenie[i];
            }
            imie_nowej_osoby[i-2] = '\0';

            //Wyciaganie wieku z wejscia
            i++;
            int j=i;
            while(zdarzenie[j] != '\n') j++;
            zdarzenie[j] = '\0';
            int wiek_nowej_osoby = atoi(zdarzenie+i);

            //Dodawanie osoby o odpowiednich danych do kolejki
            lista nowa_osoba = utworzNowaOsobe(imie_nowej_osoby, wiek_nowej_osoby);
            Lista_osob_w_kolejce = dodajOsobeNaKoniecKolejki(Lista_osob_w_kolejce, nowa_osoba);
            break;
        }
        case '-':{
            //Wyciaganie imienia z wejscia
            int i=2;
            while(zdarzenie[i] != '\n') i++;
            zdarzenie[i] = '\0';
            //Usuwanie osoby o danym imieniu
            Lista_osob_w_kolejce = usunOsobeoDanymImieniuzKolejki(Lista_osob_w_kolejce, zdarzenie+2);
            break;
        }
        case 'O':{
            //Wyciganie liczby osob opuszczajacych klub z wejscia
            int i=2;
            while(zdarzenie[i] != '\n') i++;
            zdarzenie[i] = '\0';
            int liczba_osob_opuszczajaca_klub = atoi(zdarzenie+2);
            //Obliczanie liczby wolnych miejsc w klubie
            liczba_wolnych_miejsc_w_klubie += liczba_osob_opuszczajaca_klub;
            break;
        }
        case 'F':{
            //Wyciagnie imienia osoby przychodzacej
            char imie_osoby_przychodzacej[1001];
            int i;
            for(i=2; zdarzenie[i] != ' '; i++){
                imie_osoby_przychodzacej[i-2] = zdarzenie[i];
            }
            imie_osoby_przychodzacej[i-2] = '\0';

            //Wyciaganie wieku osoby przychadzacej
            int wiek_osoby_przychadzacej;
            int j;
            for(j=i+1; zdarzenie[j] != ' '; j++);
            zdarzenie[j] = '\0';
            wiek_osoby_przychadzacej = atoi(zdarzenie+i);

            //Wyciaganie imienia kolegi
            char imie_kolegi[1001];
            for(i=j+1; zdarzenie[i] != '\n'; i++){
                imie_kolegi[i-j-1] = zdarzenie[i];
            }
            imie_kolegi[i-j-1] = '\0';

            //Tworzenie i wstawianie przychadzacej osoby przed kolege
            lista osoba_przychadzaca = utworzNowaOsobe(imie_osoby_przychodzacej, wiek_osoby_przychadzacej);
            Lista_osob_w_kolejce = wstawOsobeAprzedOsobeB(Lista_osob_w_kolejce, osoba_przychadzaca, imie_kolegi);
            break;
        }
        case 'Z':{
            czy_Z = 1;
            break;
        }
        }
        if(czy_Z == 1) break;

        //Petla wpuszczajaca ludzi do klubu
        lista iterowanie_przez_liste = Lista_osob_w_kolejce;
        while(liczba_wolnych_miejsc_w_klubie > 0){
            if(iterowanie_przez_liste != NULL){
//!                printf("iterowanie_przez_liste nie jest rowne NULL checked\n");
                if(iterowanie_przez_liste->wiek >= 18){
//!                    printf("wiek jest >= 18 checked\n");
                    liczba_wolnych_miejsc_w_klubie--;
                    //Dodawanie osob, ktore weszly do klubu na liste. Trzeba utworzyc te osoby jako osobne z nowym miejscem w pamieci
                    Lista_osob_ktore_weszly_do_klubu = dodajOsobeNaKoniecKolejki(Lista_osob_ktore_weszly_do_klubu, utworzNowaOsobe(iterowanie_przez_liste->imie, iterowanie_przez_liste->wiek));
                }
                iterowanie_przez_liste = iterowanie_przez_liste->nastepny;
                Lista_osob_w_kolejce = usunPierwszaOsobezKolejki(Lista_osob_w_kolejce);
            }
            else break;
//!            putchar('x');
//!            putchar('\n');
        }
        //!printf("W klubie jest %d miejsc\n",liczba_wolnych_miejsc_w_klubie);

        //!wypiszKolejke(Lista_osob_w_kolejce);
    }

    wypiszKolejke(Lista_osob_ktore_weszly_do_klubu);

    while(Lista_osob_w_kolejce != NULL) Lista_osob_w_kolejce = usunPierwszaOsobezKolejki(Lista_osob_w_kolejce);
    while(Lista_osob_ktore_weszly_do_klubu != NULL) Lista_osob_ktore_weszly_do_klubu = usunPierwszaOsobezKolejki(Lista_osob_ktore_weszly_do_klubu);


    return 0;
}
