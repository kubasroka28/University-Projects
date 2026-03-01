// Jakub Sroka 19.04.2025
// Zlozonosc obliczeniowa : O(N + Q * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

int usun(int x, vector<int>& lista, vector<int>& drzewo_przedzialowe, int liczba_lisci){
    int wierzcholek = 1;
    while(2 * wierzcholek + 1 <= 2 * liczba_lisci - 1){
        drzewo_przedzialowe[wierzcholek]--;
        if(drzewo_przedzialowe[2 * wierzcholek] >= x){
            wierzcholek *= 2;
        }
        else{
            x -= drzewo_przedzialowe[2 * wierzcholek];
            wierzcholek = 2 * wierzcholek + 1;
        }
    }
    drzewo_przedzialowe[wierzcholek]--;
    return lista[wierzcholek - liczba_lisci];
}

void preprocessing(int n, vector<int>& lista, int liczba_lisci, vector<int>& drzewo_przedzialowe){
    for(int i = 0; i < n; i++){
        cin>>lista[i];
        drzewo_przedzialowe[liczba_lisci + i] = 1;
    }
    for(int i = liczba_lisci - 1; i >= 1; i--){
        drzewo_przedzialowe[i] = drzewo_przedzialowe[2 * i]  + drzewo_przedzialowe[2 * i + 1];
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n;
    cin>>n;
    int liczba_lisci = 1 << static_cast<int>(ceil(log2(n)));
    // wartosc w wierzchlku mowi ile zostalo elementow w danym przedziale
    vector<int> lista (n);
    vector<int> drzewo_przedzialowe (liczba_lisci * 2, 0);
    preprocessing(n, lista, liczba_lisci, drzewo_przedzialowe);

    for(int i = 0; i < n; i++){
        int p;
        cin>>p;
        cout<<usun(p, lista, drzewo_przedzialowe, liczba_lisci)<<" ";
    }

    return 0;
}



