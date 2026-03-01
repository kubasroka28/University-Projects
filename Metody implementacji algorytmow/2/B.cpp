// B. Banknotes
#include <iostream>
#include <vector>
using namespace std;
#define ll long long
 
int main(){
    ios_base::sync_with_stdio(0); 
    cin.tie(0);
    cout.tie(0);
        
    vector<int> ten_pows = {1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000, 1000000000};


    int t;
    cin>>t;
    while(t--){
        int n, k;
        cin>>n>>k;
        vector<ll> denoms(n);
        for(int i = 0; i < n; i++){
            int a;
            cin>>a;
            denoms[i] = ten_pows[a];
        }

        ll s = 0;
        for(int i = 0; i < n; i++){
            if(k < 0) break;
            if(i == n - 1){
                s += (k + 1) * denoms[i];
                break;
            }
            ll temp = min(k + 1LL, (denoms[i+1] - denoms[i]) / denoms[i]);
            k -= temp;
            s += 1LL * temp * denoms[i];
        }        
        cout<<s<<"\n";
    }
    return 0;
}
