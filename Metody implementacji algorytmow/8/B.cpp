//B. Yuu Koito and Minimum Absolute Sum
#include <bits/stdc++.h>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int t;
    cin>>t;
    while(t--){
        int n;
        cin>>n;
        vector<int> a(n);
        int anwser = 0;
        for(int i = 0; i < n; i++){
            cin>>a[i];
            if(a[i] == -1 && i != 0 && i != n - 1) a[i] = 0;
        }
        if(a[0] == -1 && a[n-1] == -1){
            a[0] = 0;
            a[n-1] = 0;
        }
        else if(a[0] == -1){
            a[0] = a[n-1];
        }
        else if(a[n-1] == -1){
            a[n-1] = a[0];
        }
        anwser = abs(a[0] - a[n-1]);
        cout<<anwser<<"\n";
        for(int i = 0; i < n; i++){
            cout<<a[i]<<" ";
        }
        cout<<"\n";
    }
    return 0;
}