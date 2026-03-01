//B. Diamond Miner
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
        vector<int> miners, mines;
        for(int i = 0; i < 2*n; i++){
            int x, y;
            cin>>x>>y;
            if(x == 0) miners.push_back(abs(y));
            else mines.push_back(abs(x)); 
        }
        sort(miners.begin(),miners.end());
        sort(mines.begin(), mines.end());
        double anwser = 0.0;
        for(int i = 0; i < n; i++){
            anwser += sqrt(1LL*miners[i]*miners[i] + 1LL*mines[i]*mines[i]);//1LL*
        }
        cout<<setprecision(20)<<anwser<<"\n";

        // for(int i = 0; i < n; i++){
        //     cout<<"("<<miners[i]<<", "<<((miners[i])^2)<<") ";
        // }    
        // cout<<"\n";
        // for(int i = 0; i < n; i++){
        //     cout<<"("<<mines[i]<<", "<<(mines[i]^2)<<") ";
        // }
        // cout<<"\n\n";
    }

    return 0;
}