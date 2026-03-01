#include <iostream>
#include <vector>

#define LL long long
#define MOD 1000000007
#define TOP 1000000

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

void calculate_factorials (vector<LL>& factorials){
    factorials[0] = 1;
    for(int i=1; i<=TOP; i++){
        factorials[i] = (factorials[i-1] * i) % MOD;
    }
}

void calculate_inversed_factorials (LL top_factorial, vector<LL>& inversed_factorials){
    LL x, y;
    extended_GCD(top_factorial, MOD, x, y);
    inversed_factorials[TOP] = (x % MOD + MOD) % MOD;
    for(int i=TOP-1; i>=0; i--){
        inversed_factorials[i] = (inversed_factorials[i+1] * (i+1)) % MOD;
    }
}

int main(){
    int N;
    cin>>N;
    vector<LL> factorials(TOP+1);
    vector<LL> inversed_factorials(TOP+1);
    calculate_factorials (factorials);
    calculate_inversed_factorials (factorials[TOP], inversed_factorials);

    for(int i=0; i<N; i++){
        LL a, b;
        cin>>a>>b;
        cout<<((((factorials[a] * inversed_factorials[b]) % MOD) * inversed_factorials[a-b]) % MOD)<<"\n";
    }

    return 0;
}
