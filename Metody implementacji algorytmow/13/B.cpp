//B. T-primes
#include <bits/stdc++.h>
using namespace std;
#define ten_pow6p1 1000001
#define sqrt_ten_pow6_p1 1001
#define ll long long
 
//T-primes are squares of prime numbers

void Eratostenes_sieve(vector<bool>& numbers){
    numbers[0] = false;
    numbers[1] = false;
    int d = 2;
    while(d < sqrt_ten_pow6_p1){
        int m = 2;
        while(m * d < ten_pow6p1){
            numbers[m * d] = false;
            m++;
        }
        d++;
    }
return;
}

bool find(vector<ll>& T_primes, ll x){
    int l = 0, m, r = T_primes.size() - 1;
    while(l <= r){
        m = l + (r - l) / 2;

        if(T_primes[m] == x) return true;

        if(x > T_primes[m]) l = m + 1;
        else r = m - 1;
    }
    return false;
}

/*
10
4 361 8374 4489 100000000043 1427403961 2384762 89298346227 905053503649 121
YES YES NO YES NO YES NO NO YES YES
*/

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  

    vector<bool> primes(ten_pow6p1, true);
    Eratostenes_sieve(primes); 
    
    vector<ll> T_primes;
    int T_primes_counter = 0;
    for(int i = 0; i < ten_pow6p1; i++){
        if(primes[i]){
            T_primes.push_back(1LL * i * i);
            T_primes_counter++;
        } 
    }

    // int start = 75000;
    // for(int i = start; i < start+10; i++){
    //     cout<<T_primes[i]<<"\n";
    // }

    int n;
    cin>>n;
    for(int i = 0; i < n; i++){
        ll x;
        cin>>x;
        if(find(T_primes, x)){
            cout<<"YES\n";
        }
        else cout<<"NO\n";
    }    

    return 0;
}