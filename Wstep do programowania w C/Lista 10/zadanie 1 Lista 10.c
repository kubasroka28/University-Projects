#include <stdio.h>

struct wezel_drzewa{
    struct wezel_drzewa** nastepna_kolumna;
    int numer_kolumny;
    int czy_pole_atakowane;
};
typedef struct wezel_drzewa Wezel_drzewa;

Wezel_drzewa* utworz_wezel(int n, int numer_kolumny_nowego_wezla, int dostepnosc_pola){
    Wezel_drzewa* nowy_wezel = malloc(sizeof(Wezel_drzewa));
    if(nowy_wezel == NULL){
        printf("Alokacja pamieci dla nowego wezla nie powiodla sie");
        return NULL;
    }

    nowy_wezel->nastepna_kolumna = malloc(sizeof(Wezel_drzewa*) * n);
    if(nowy_wezel->nastepna_kolumna == NULL){
        printf("Alokacja pamieci dla nowego wezla nie powiodla sie");
        free(nowy_wezel);
        return NULL;
    }
    for(int i=0; i<n; i++){
        nowy_wezel->nastepna_kolumna[i] = NULL;
    }

    nowy_wezel->numer_kolumny = numer_kolumny_nowego_wezla;
    nowy_wezel->czy_pole_atakowane = dostepnosc_pola;

    return nowy_wezel;
}

// k - kolumna sprawdzanego pola; p - plansza z pozycjami hetmanow
// zwraca numer kolumny, w ktorej jest hetman atakujacy sprawdzane pole
// albo jezeli taki nie istnieje to zwarca -1
int isfree(int k, int p[]){
    for(int i=0; i<k; i++){
        if(p[i]==p[k] || p[i]-i==p[k]-k || p[i]+i==p[k]+k) return i;
    }
    return -1;
}

void HetmanRek(Wezel_drzewa* drzewo[], int n, int plansza[], int k){
    if(k==n) return;

    for(int i=0; i<n; i++){
        plansza[k]=i;
        int obliczone_isfree = isfree(k,plansza);
        drzewo[i] = utworz_wezel(n, k, obliczone_isfree);
        if(obliczone_isfree == -1){
            HetmanRek(drzewo[i]->nastepna_kolumna, n, plansza, k+1);
        }
    }
}

void drukowanie_drzewa(Wezel_drzewa* drzewo[], int n, int k){
    for(int i=0; i<n; i++){
        for (int j=0; j<k; j++) printf("  ");
        if(drzewo[i] != NULL){
            if(drzewo[i]->czy_pole_atakowane == -1){
                if(k == n-1){
                    printf("Kolumna %d wiersz %d nie jest atakowany, stawiamy hetmana - SUKCES!\n", k, i);
                }
                else{
                    printf("Kolumna %d wiersz %d nie jest atakowany, stawiamy hetmana\n", k, i);
                    drukowanie_drzewa(drzewo[i]->nastepna_kolumna, n, k+1);
                }
            }
            else{
                printf("Kolumna %d wiersz %d jest atakowany przez hetmana z kolumny %d\n", k, i, drzewo[i]->czy_pole_atakowane);
            }
        }
    }
}

void zwalnianie_pamieci(Wezel_drzewa* drzewo[], int n) {
    for (int i=0; i<n; i++){
        if (drzewo[i] != NULL){
            zwalnianie_pamieci(drzewo[i]->nastepna_kolumna, n);
            free(drzewo[i]->nastepna_kolumna);
            free(drzewo[i]);
        }
    }
}


int main(int argc, char const *argv[])
{
    //Obsluga danych wejsciowych
    if(argc<2){
        printf("Brak danych wejsciowych o rozmiarze planszy\n");
        return 1;
    }
    for(int i=0; i<strlen(argv[1]); i++)
    {
        if(!isdigit(argv[1][i])){
            printf("Podany rozmiar planszy nie jest liczba\n");
            return 1;
        }
    }
    int n = atoi(argv[1]);
    //Drzewo decyzyjne to tablica zawierajaca wskazniki na n wezlow drzewa
    Wezel_drzewa* drzewo_decyzyjne[n];
    for(int i=0; i<n; i++){
        drzewo_decyzyjne[i] = utworz_wezel(n,0,-1);
    }
    //Tablica zapisujaca pozycje hetmanow na planszy
    int Plansza_na_hetmany[n];
    for(int i=0; i<n; i++) Plansza_na_hetmany[i] = (-1);
    //Rozwiazywanie problemu n Hetmanow
    HetmanRek(drzewo_decyzyjne, n, Plansza_na_hetmany, 0);
    //Drukowanie drzewa decyzyjnego oraz zwalnianie pamieci
    drukowanie_drzewa(drzewo_decyzyjne, n, 0);
    zwalnianie_pamieci(drzewo_decyzyjne, n);

    return 0;
}
