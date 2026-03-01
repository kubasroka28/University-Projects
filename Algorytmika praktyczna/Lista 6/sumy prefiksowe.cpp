#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

int policz(int k, vector<int>& drzewo_przedzialowe, int liczba_lisci){
    int wierzcholek = liczba_lisci - 1 + k;
    int suma_prefiksowa = drzewo_przedzialowe[wierzcholek];
    while(wierzcholek > 1){
        if(wierzcholek % 2 == 1){
            suma_prefiksowa += drzewo_przedzialowe[wierzcholek - 1];
        }
        wierzcholek /= 2;
    }
    return suma_prefiksowa;
}

void zamien(int k, int x,  vector<int>& drzewo_przedzialowe, int liczba_lisci){
    int wierzcholek = liczba_lisci - 1 + k;
    int stara_wartosc = drzewo_przedzialowe[wierzcholek];
    while(wierzcholek >= 1){
        drzewo_przedzialowe[wierzcholek] += x - stara_wartosc;
        wierzcholek /= 2;
    }
}

void preprocessing(int n, int liczba_lisci, vector<int>& drzewo_przedzialowe){
    for(int i = 0; i < n; i++){
        cin>>drzewo_przedzialowe[liczba_lisci + i];
    }
    for(int i = liczba_lisci - 1; i >= 1; i--){
        drzewo_przedzialowe[i] = drzewo_przedzialowe[2 * i] + drzewo_przedzialowe[2 * i + 1];
    }
}

int main(){
    int n;
    cin>>n;
    int liczba_lisci = 1 << static_cast<int>(ceil(log2(n)));
    vector<int> drzewo_przedzialowe (liczba_lisci * 2, 0);
    preprocessing(n, liczba_lisci, drzewo_przedzialowe);

    cout<<"\n";
    for(int i = 1; i <= n; i++){
        cout<<policz(i, drzewo_przedzialowe, liczba_lisci)<<" ";
    }

    return 0;
}


