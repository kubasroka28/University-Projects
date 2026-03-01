//A. Basketball Together
#include <bits/stdc++.h>
using namespace std;
#define ll long long

//This function returns the amount of emotes in a triangle of size k from messages numbered 1-m
ll emotes_amount(ll m, ll k){
    if(m <= k) return (1+m)*m/2;
    else return (1+k)*k/2 + (1+(k-1))*(k-1)/2 - emotes_amount(2*k-(m+1), k);
}

//This function finds the biggest possible amount of messages you can send before getting banned 
ll bin_search(ll x, ll k){
    ll s = 1, e = 2*k - 1;
    while(s != e){
        ll m = (s + e)/2;
        ll amount = emotes_amount(m, k);
        if(amount < x) s = m + 1;
        else if(amount > x) e = m;
        else return m;
    }
    return s;
}

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
    
    int t;
    cin>>t;
    while(t--){
        ll k, x;
        cin>>k>>x;
        cout<<bin_search(x, k)<<"\n";
    }
    return 0;
}