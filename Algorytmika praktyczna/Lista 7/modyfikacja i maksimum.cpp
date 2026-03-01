// Jakub Sroka 21.04.2025
// Zlozonosc obliczeniowa : O(N + Q * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

typedef struct Wierzcholek{
    int maks;
    int modyfikacja;
}wierzcholek;

int policz_maks(int nr, int zp, int zk, int p, int k, int sciezka, vector<wierzcholek>& drzewo_przedzialowe){
    if(zp == p && zk == k) return drzewo_przedzialowe[nr].maks + sciezka;
    int s = (zp + zk) / 2;
    if(zp <= p && k <= s){
        return policz_maks(2 * nr, zp, s, p, k, sciezka + drzewo_przedzialowe[nr].modyfikacja, drzewo_przedzialowe);
    }
    else if(s + 1 <= p && k <= zk){
        return policz_maks(2 * nr + 1, s + 1, zk, p, k, sciezka + drzewo_przedzialowe[nr].modyfikacja, drzewo_przedzialowe);
    }
    else{
        int lewo = policz_maks(2 * nr, zp, s, p, s, sciezka + drzewo_przedzialowe[nr].modyfikacja, drzewo_przedzialowe);
        int prawo = policz_maks(2 * nr + 1, s + 1, zk, s + 1, k, sciezka + drzewo_przedzialowe[nr].modyfikacja, drzewo_przedzialowe);
        return max(lewo, prawo);
    }
}

void aktualizacja(int nr, vector<wierzcholek>& drzewo_przedzialowe){
    while(nr >= 1){
        drzewo_przedzialowe[nr].maks = max(drzewo_przedzialowe[2 * nr].maks, drzewo_przedzialowe[2 * nr + 1].maks) + drzewo_przedzialowe[nr].modyfikacja;
        nr /= 2;
    }
}

void dodaj(int nr, int zp, int zk, int p, int k, int l, vector<wierzcholek>& drzewo_przedzialowe){
    if(zp == p && zk == k){
        drzewo_przedzialowe[nr].modyfikacja += l;
        drzewo_przedzialowe[nr].maks += l;
        aktualizacja(nr / 2, drzewo_przedzialowe);
    }
    else{
        int s = (zp + zk) / 2;
        if(zp <= p && k <= s){
            dodaj(2 * nr, zp, s, p, k, l, drzewo_przedzialowe);
        }
        else if(s + 1 <= p && k <= zk){
            dodaj(2 * nr + 1, s + 1, zk, p, k, l, drzewo_przedzialowe);
        }
        else{
            dodaj(2 * nr, zp, s, p, s, l, drzewo_przedzialowe);
            dodaj(2 * nr + 1, s + 1, zk, s + 1, k, l, drzewo_przedzialowe);
        }
    }
}

void preprocessing(int n, int liczba_lisci, vector<wierzcholek>& drzewo_przedzialowe){
    for(int i = 0; i < n; i++){
        cin>>drzewo_przedzialowe[liczba_lisci + i].maks;
    }
    for(int i = liczba_lisci - 1; i >= 1; i--){
        drzewo_przedzialowe[i].maks = max(drzewo_przedzialowe[2 * i].maks, drzewo_przedzialowe[2 * i + 1].maks);
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    int liczba_lisci = 1 << static_cast<int>(ceil(log2(n)));
    // wartosc w wierzchlku mowi ile na danym odciunku miejsc jest zajeta i jaka jest minimalna liczba wolnych miejsc
    vector<wierzcholek> drzewo_przedzialowe (liczba_lisci * 2, {0, 0});
    preprocessing(n, liczba_lisci, drzewo_przedzialowe);

    for(int i = 0; i < q; i++){
        int op_type;
        cin>>op_type;
        if(op_type == 1){
            int p, k, l;
            cin>>p>>k>>l;
            dodaj(1, 1, liczba_lisci, p, k, l, drzewo_przedzialowe);
        }
        else{
            int p, k;
            cin>>p>>k;
            cout<<policz_maks(1, 1, liczba_lisci, p, k, 0, drzewo_przedzialowe)<<"\n";
        }
    }

    return 0;
}


/*
8 10
3 5 8 7 1 4 5 9
2 1 2
2 3 7
1 1 1 10
2 1 8
1 3 8 5
1 6 8 10
2 2 8
1 1 5 15
2 3 5
2 5 7

odp:
5
8
13
24
28
21
*/

