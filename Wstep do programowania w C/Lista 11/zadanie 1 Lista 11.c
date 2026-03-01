#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//Maksymalna dlugosc skrotu nazwy komitetu wyborczego jest prawnie ustalona jako 45 znakow drukarskich wliczajac spacje
#define MDK 46 //45+1 na null terminator
//Maksymalna liczba komitetow wyborczych
#define MLK 100
//Maksymalna dlugosc nazwy okregu wyborczego
#define MDO 46
//Liczba okregow wyborczych
#define LO 41

//Funkcja wczytuje do bufora napis az napotka srednik lub zlamanie wiersza
//W pierwszym przypadku zwraca 1, a w drugim 0
int wczytaj_fragment(char* napis){
    int c = 0;
    int znak = 0;
    while((c = getchar()) != '\n'){//EOF && c !=
        if(c == ';'){
            napis[znak] = '\0';
            return 1;
        }
        napis[znak] = c;
        znak++;
    }
    napis[znak] = '\0';
    return 0;
}

//Funkcja wczytuje nazwy komitetow i zwraca ich ilosc
void wczytaj_naglowek(char fKomitety[MLK][MDK], int *l_k){
    int liczba_komitetow = 0;
    //pozbywamy sie najpierw naglowkow "okregi" i "mandaty"
    wczytaj_fragment(fKomitety[liczba_komitetow]);
    wczytaj_fragment(fKomitety[liczba_komitetow]);
    while(wczytaj_fragment(fKomitety[liczba_komitetow])){
        liczba_komitetow++;
        if(liczba_komitetow == MLK) break;
    }
    liczba_komitetow++;
    *l_k = liczba_komitetow;
}

void wczytaj_okregi_mandaty_glosy(char fOkregi[LO][MDO], int fLiczbaMandatowNaOkrag[LO], int fGlosy[LO][MLK], int fliczba_komitetow, int *w_g){
    int wszystkie_glosy = 0;
    for(int i=0; i<LO; i++){
        //wczytywanie nazwy okregu
        wczytaj_fragment(fOkregi[i]);
        //wczytywanie liczby mandatow na okrag
        char wczytywanie_liczb[10];
        wczytaj_fragment(wczytywanie_liczb);
        fLiczbaMandatowNaOkrag[i] = atoi(wczytywanie_liczb);
        //wczytywanie glosow w poszczegolnych okregach dla poszczegolnych komitetow
        for(int j=0; j<fliczba_komitetow; j++){
            wczytaj_fragment(wczytywanie_liczb);
            fGlosy[i][j] = atoi(wczytywanie_liczb);
            wszystkie_glosy += fGlosy[i][j];
        }
    }
    *w_g = wszystkie_glosy;
}

struct Element_zbioru_ilorazow{
    int Iloraz;
    int Liczba_glosow_komitetu;
    int Indeks_komitetu;
};

int komparator_ilorazow( const void *w1, const void *w2 ){
    struct Element_zbioru_ilorazow *wynik1 = (struct Element_zbioru_ilorazow *)w1;
    struct Element_zbioru_ilorazow *wynik2 = (struct Element_zbioru_ilorazow *)w2;
    if(wynik1->Iloraz != wynik2->Iloraz){
        return wynik2->Iloraz - wynik1->Iloraz;
    }
    return wynik2->Liczba_glosow_komitetu - wynik1->Liczba_glosow_komitetu;
}

void liczenieMandatow(int l_k_p_p, int MnaK[LO][l_k_p_p], int l_m_n_o[LO], int Glosy[LO][MLK], int K_p_p[l_k_p_p]){
    //inicjowanie zerami
    for(int i=0; i<LO; i++){
        for(int j=0; j<l_k_p_p; j++){
            MnaK[i][j] = 0;
        }
    }

    for(int i=0; i<LO; i++){
        struct Element_zbioru_ilorazow Zbior_ilorazow[l_m_n_o[i] * l_k_p_p]; //Zbior_ilorazow={Kom1/1, Kom2/1,..., Komn/1, Kom1/2, Kom2/2,..., Komn/2,..., Kom1/n,..., Komn/n}
        for(int j=1; j<=l_m_n_o[i]; j++){
            for(int k=0; k<l_k_p_p; k++){
                //tutaj licze iloraz komitetu k przez liczbe j
                Zbior_ilorazow[l_k_p_p * (j-1) + k]. Iloraz = Glosy[i][K_p_p[k]] / j;
                Zbior_ilorazow[l_k_p_p * (j-1) + k]. Liczba_glosow_komitetu = Glosy[i][K_p_p[k]];
                Zbior_ilorazow[l_k_p_p * (j-1) + k]. Indeks_komitetu = K_p_p[k];
            }
        }

        qsort(Zbior_ilorazow, l_m_n_o[i] * l_k_p_p, sizeof(struct Element_zbioru_ilorazow), komparator_ilorazow);

        for(int j=0; j<l_m_n_o[i]; j++){
            for(int k=0; k<l_k_p_p; k++){
                if(K_p_p[k] == Zbior_ilorazow[j].Indeks_komitetu){
                    MnaK[i][k]++;
                    break;
                }
            }
        }
    }
}

void wypiszMandaty(int l_k_p_p, int Mandaty[LO][l_k_p_p], char Nazwy_okregow[LO][MDO], char Nazwy_komitetow[MLK][MDK], int Indeksy_komitetow_ponad_progiem[l_k_p_p]){
    int CzyZeroMandatow[l_k_p_p];
    for(int i=0; i<l_k_p_p; i++){
        CzyZeroMandatow[i] = 0;
        for(int j=0; j<LO; j++){
            if(Mandaty[j][i] != 0){
                CzyZeroMandatow[i] = 1;
                break;
            }
        }
    }

    printf("%28s"," ");
    for(int i=0; i<l_k_p_p; i++){
        if(CzyZeroMandatow != 0){
            printf("%10s ", Nazwy_komitetow[Indeksy_komitetow_ponad_progiem[i]]);
        }
    }
    putchar('\n');

    for(int i=0; i<LO; i++){
        printf("Mandaty w okregu %-10s:", Nazwy_okregow[i]);
        for(int j=0; j<l_k_p_p; j++){
            printf("%10d ", Mandaty[i][j]);
        }
        putchar('\n');
    }
}

int main(){

    char Komitety[MLK][MDK];
    char Okregi[LO][MDO];
    int LiczbaMandatowNaOkrag[LO];
    int Glosy[LO][MLK]; //[Okreg][Komitet]

    //czy w zadaniach takiego typu mozemy podczas wczytywania zakladac jakies maksymalne dlugosci lini?
    int liczba_komitetow = 0;
    wczytaj_naglowek(Komitety, &liczba_komitetow);
    int ilosc_wszystkich_glosow = 0;
    wczytaj_okregi_mandaty_glosy(Okregi, LiczbaMandatowNaOkrag, Glosy, liczba_komitetow, &ilosc_wszystkich_glosow);

    //Sprawdzanie progu wyborczego
    int liczba_komitetow_ponad_progiem = 0;
    int Czy_komitet_ponad_progiem[liczba_komitetow]; // 1 kiedy komitet jest ponad progiem, 0 wpp
    for(int i=0; i<liczba_komitetow; i++){
        int suma_komitetu = 0;
        for(int j=0; j<LO; j++){
            suma_komitetu += Glosy[j][i];
        }
        if(suma_komitetu > 0.05 * ilosc_wszystkich_glosow){
            Czy_komitet_ponad_progiem[i] = 1;
            liczba_komitetow_ponad_progiem++;
        }
        else Czy_komitet_ponad_progiem[i] = 0;
    }
    int Komitety_ponad_progiem[liczba_komitetow_ponad_progiem];
    liczba_komitetow_ponad_progiem = 0;
    for(int i=0; i<liczba_komitetow; i++){
        if(Czy_komitet_ponad_progiem[i] == 1){
            Komitety_ponad_progiem[liczba_komitetow_ponad_progiem] = i;
            liczba_komitetow_ponad_progiem++;
        }
    }

    //Liczenie ilorazow w kazdym okregu
    int MandatyNaKomitety[LO][liczba_komitetow_ponad_progiem];
    liczenieMandatow(liczba_komitetow_ponad_progiem, MandatyNaKomitety, LiczbaMandatowNaOkrag, Glosy, Komitety_ponad_progiem);

    wypiszMandaty(liczba_komitetow_ponad_progiem, MandatyNaKomitety, Okregi, Komitety, Komitety_ponad_progiem);

    return 0;
}

