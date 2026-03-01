// O(nlogn)

#include <iostream>
using namespace std;

long long gcd(long long a, long long b, long long& x, long long& y) {
    if (b == 0) {
        x = 1;
        y = 0;
        return a;
    }
    long long x1, y1;
    long long d = gcd(b, a % b, x1, y1);
    x = y1;
    y = x1 - y1 * (a / b);
    return d;
}

int main(){
    int N;
    cin>>N;

    for(int i=0; i<N; i++){
        int K;
        cin>>K;
        long long wynik = 0;
        long long pierwsze[K];
        long long reszty[K];
        for(int j=0; j<K; j++){
            cin>> pierwsze[j] >> reszty[j];
        }
        long long iloczyn_pierwszych = 1;
        for(int j=0; j<K; j++){
            iloczyn_pierwszych *= pierwsze[j];
        }

        for(int j=0; j<K; j++){
            long long x, y;
            gcd(iloczyn_pierwszych / pierwsze[j], pierwsze[j], x, y);
            wynik += (iloczyn_pierwszych / pierwsze[j]) * x * reszty[j];

        }
        wynik %= iloczyn_pierwszych;
            while(wynik < 0){
                wynik += iloczyn_pierwszych;
            }
        cout<< wynik << "\n";

    }
}
