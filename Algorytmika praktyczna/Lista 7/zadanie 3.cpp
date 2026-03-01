// Jakub Sroka 22.04.2025
// Zlozonosc obliczeniowa : O(N + Q * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

typedef struct Wierzcholek{
    int maks;
    int modyfikacja;
}wierzcholek;

void aktualizacja(int nr, vector<wierzcholek>& drzewo){
    nr /= 2;
    while(nr >= 1){
        drzewo[nr].maks = max(drzewo[2 * nr].maks + drzewo[2 * nr].modyfikacja, drzewo[2 * nr + 1].maks + drzewo[2 * nr + 1].modyfikacja);
        nr /= 2;
    }
}

void dodaj(int nr, int zp, int zk, int p, int k, int l, vector<wierzcholek>& drzewo){
    if(zp == p && zk == k){
        drzewo[nr].modyfikacja += l;
        //v1
        //aktualizacja(nr, l, drzewo);
    }
    else{
        int s = (zp + zk) / 2;
        if(zp <= p && k <= s){
            dodaj(2 * nr, zp, s, p, k, l, drzewo);
        }
        else if(s + 1 <= p && k <= zk){
            dodaj(2 * nr + 1, s + 1, zk, p, k, l, drzewo);
        }
        else{
            dodaj(2 * nr, zp, s, p, s, l, drzewo);
            dodaj(2 * nr + 1, s + 1, zk, s + 1, k, l, drzewo);
        }
    }
    //v2
    if(zp != zk){
        drzewo[nr].maks = max(drzewo[2 * nr].maks + drzewo[2 * nr].modyfikacja, drzewo[2 * nr + 1].maks + drzewo[2 * nr + 1].modyfikacja);
    }
}

int policz_maks(int nr, int zp, int zk, int p, int k, vector<wierzcholek>& drzewo, int sciezka){
    if(zp == p && zk == k){
        return drzewo[nr].maks + drzewo[nr].modyfikacja + sciezka;
    }
    else{
        int s = (zp + zk) / 2;
        if(zp <= p && k <= s){
            return policz_maks(2 * nr, zp, s, p, k, drzewo, sciezka + drzewo[nr].modyfikacja);
        }
        else if(s + 1 <= p && k <= zk){
            return policz_maks(2 * nr + 1, s + 1, zk, p, k, drzewo, sciezka + drzewo[nr].modyfikacja);
        }
        else{
            int lewo = policz_maks(2 * nr, zp, s, p, s, drzewo, sciezka + drzewo[nr].modyfikacja);
            int prawo = policz_maks(2 * nr + 1, s + 1, zk, s + 1, k, drzewo, sciezka + drzewo[nr].modyfikacja);
            return max(lewo, prawo);
        }
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, m, q;
    cin>>n>>m>>q;
    int liczba_lisci = 1 << static_cast<int>(ceil(log2(n - 1)));
    // wartosc w wierzchlku mowi ile na danym odciunku miejsc jest zajeta i jaka jest maksymalna liczba zajetych miejsc
    vector<wierzcholek> drzewo_przedzialowe (liczba_lisci * 2, {0, 0});

    for(int i = 0; i < q; i++){
        int p, k, l;
        cin>>p>>k>>l;
        if(policz_maks(1, 1, liczba_lisci, p, k - 1, drzewo_przedzialowe, 0) + l <= m){
            cout<<'T'<<"\n";
            dodaj(1, 1, liczba_lisci, p, k - 1, l, drzewo_przedzialowe);
        }
        else cout<<'N'<<"\n";
    }
    return 0;
}


