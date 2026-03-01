//A. Find Extra One
#include <bits/stdc++.h>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int n;
    cin>>n;
    int pos = 0, neg = 0;
    for(int i = 0; i < n; i++){
        int x, y;
        cin>>x>>y;
        if(x < 0) neg++;
        else pos++;
    }
    if(pos >= 2 && neg >= 2) cout<<"No";
    else cout<<"Yes";

    return 0;
}