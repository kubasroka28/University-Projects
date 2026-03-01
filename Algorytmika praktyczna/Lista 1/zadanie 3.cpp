#include <iostream>

using namespace std;

int IleDzielnikow(int x){
    int licznik = 0;
    int i=1;
    for(i; i*i<=x; i++){
        if(x % i == 0) licznik+=2;
    }
    if((i-1)*(i-1) == x) licznik--;

    return licznik;
}

int IleDzielnikowPrzezRozklad(int x){
    int licznik = 1;
    int Rozklad[x];
    for(int k=0; k<x; k++){
        Rozklad[k] = 0;
    }

    int i=2;
    while(x != 1){
        if(x%i == 0)
        {
            x/=i;
            Rozklad[i]++;
        }
        else i++;
    }

    for(int k=0; k<x; k++){
        licznik*=Rozklad[k]+1;
    }

    return licznik;
}

int main(){
    int N = 0;
    cin>>N;
    int X[N];
    for(int i=0; i<N; i++){
        cin>>X[i];
    }
    for(int i=0; i<N; i++){
        cout<<IleDzielnikow(X[i])<<"\n";
    }
    cout<<"---\n";
    for(int i=0; i<N; i++){
        cout<<IleDzielnikowPrzezRozklad(X[i])<<"\n";
    }
    return 0;
}
