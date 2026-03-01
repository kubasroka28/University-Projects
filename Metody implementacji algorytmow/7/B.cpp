//B. Poisoned Dagger
#include <bits/stdc++.h>
using namespace std;

#define ll long long
 
/*
k >= ceil(h/n)
k <= max(h - (n - 1), 1)

I can calculate the time distance beetween each attack.
This says what's the maximum damage Monocarp can deal in i-th attack.
I can store this in max_dmg[i]

If I choose a certain k value I can check whether it's enough in O(n) time.
I do this by taking a sum over all i of min(k, max_dmg[i]) and checking
wether the result is greater or equal to h.

Minimum k is 1 (or ceil(h/n) to be precise).
Maximum k is h (or max(h - (n-1), 1) to be precise).
With binary search I find the smallest k which satisfies the task.

The time complexity is O(n * log(h))

4
2 5
1 5
3 10
2 4 10
5 3
1 2 4 5 7
4 1000
3 25 64 1337
*/

bool is_k_valid(ll k, ll n, ll h, vector<ll> mxd){
    ll dmg = 0;
    for(int i = 0; i < n; i++){
        dmg += min(k, mxd[i]);
    }
    return dmg >= h;
}

int main(){
    int t;
    cin>>t;
    while(t--){
        ll n, h;
        cin>>n>>h;
        vector<int> a(n);
        for(int i = 0; i < n; i++){
            cin>>a[i];
        }
        vector<ll> mxd(n); //maximum damage the i-th dagger attack poison can deal
        for(int i = 0; i < n - 1; i++){
            mxd[i] = a[i+1] - a[i];
        }
        mxd[n-1] = LLONG_MAX;

        ll l, k, r;
        l = 1; //ceil((1.0 * h)/n);
        r = h; //max(h - (n - 1), 1LL);
        while(l != r){
            k = (l + r) / 2;
            if(is_k_valid(k, n, h, mxd)) r = k;
            else l = k + 1;
        }
        cout<<l<<"\n";
    }
}