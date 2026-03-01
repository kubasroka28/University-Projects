// Jakub Sroka 13.03.2024

#include <iostream>
#define LL long long

using namespace std;

LL extended_GCD(LL a, LL b, LL &x, LL &y){
    if (b == 0){
        x = 1;
        y = 0;
        return a;
    }
    else{
        LL x1, y1;
        LL d = extended_GCD (b, a % b, x1, y1);
        x = y1;
        y = x1 - (a / b) * y1;
        return d;
    }
}

int main(){
    int N=0;
    cin>>N;
    for(int i=0; i<N; i++){
        LL a, b, d, x, y;
        cin>>a>>b;
        d = extended_GCD(a, b, x, y);
        cout<<x<<" "<<y<<" "<<d<<"\n";
    }
    return 0;
}
