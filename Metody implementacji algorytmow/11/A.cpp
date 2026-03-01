//A. GCD Sum
#include <bits/stdc++.h>
using namespace std;
#define ll long long
 
ll gcd(ll a, ll b){
    if(b == 0) return a;
    else return gcd(b, a % b);
}

ll sum_of_digits(ll x){
    int sum_of_digits = 0;
    while(x != 0){
        sum_of_digits += x % 10;
        x /= 10;
    }
    return sum_of_digits;
}

ll gcdSum(ll x){
    return gcd(x, sum_of_digits(x));
}

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int t;
    cin>>t;
    while(t--){
        ll n;
        cin>>n;
        while(gcdSum(n) <= 1) n++;
        cout<<n<<"\n";
    }
    return 0;
}