// Jakub Sroka 18.04.2025
// Zlozonosc obliczeniowa : O(N + Q * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

void wydanie_pokoi(int v, int x, vector<int>& drzewo_przedzialowe, int liczba_lisci){
    drzewo_przedzialowe[x] -= v;
    x /= 2;
    while(x >= 1){
        drzewo_przedzialowe[x] = max(drzewo_przedzialowe[2 * x], drzewo_przedzialowe[2 * x + 1]);
        x /= 2;
    }
}

int ktory_hotel(int v, vector<int>& drzewo_przedzialowe, int liczba_lisci){
    int wierzcholek = 1;
    int hotel = 0;
    while(2 * wierzcholek + 1 <= 2 * liczba_lisci - 1){
        if(drzewo_przedzialowe[2 * wierzcholek] >= v){
            wierzcholek *= 2;
        }
        else if(drzewo_przedzialowe[2 * wierzcholek + 1] >= v){
            wierzcholek = 2 * wierzcholek + 1;
        }
        else break;
    }
    if(drzewo_przedzialowe[wierzcholek] >= v){
        hotel = wierzcholek - (liczba_lisci - 1);
        wydanie_pokoi(v, wierzcholek, drzewo_przedzialowe, liczba_lisci);
    }

    return hotel;
}

void preprocessing(int n, int liczba_lisci, vector<int>& drzewo_przedzialowe){
    for(int i = 0; i < n; i++){
        cin>>drzewo_przedzialowe[liczba_lisci + i];
    }
    for(int i = liczba_lisci - 1; i >= 1; i--){
        drzewo_przedzialowe[i] = max(drzewo_przedzialowe[2 * i], drzewo_przedzialowe[2 * i + 1]);
    }
}

int main(){
    int n, q;
    cin>>n>>q;
    int liczba_lisci = 1 << static_cast<int>(ceil(log2(n)));
    // wartosc w wierzchlku mowi jaka jest maksymalna liczba wolnych pokoi na przedziale
    vector<int> drzewo_przedzialowe (liczba_lisci * 2, 0);
    preprocessing(n, liczba_lisci, drzewo_przedzialowe);

    for(int i = 0; i < q; i++){
        int v;
        cin>>v;
        cout<<ktory_hotel(v, drzewo_przedzialowe, liczba_lisci)<<" ";
    }

    return 0;
}



