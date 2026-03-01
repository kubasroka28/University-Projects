//C. Weakened Common Divisor
#include <bits/stdc++.h>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int n;
    cin>>n;
    vector<pair<int,int>> list(n);
    for(int i = 0; i < n; i++){
        cin>>list[i].first>>list[i].second;
    }
    vector<int> possible_WCD;
    int f = list[0].first, s = list[0].second;
 
    for(int d = 2; d * d <= max(f, s); d++){
        if(f % d == 0){
            possible_WCD.push_back(d);
            while(f % d == 0) f /= d;
        }
        if(s % d == 0){
            if(!possible_WCD.empty()){
                if(possible_WCD.back() != d){
                    possible_WCD.push_back(d);
                }                
            }
            else{
                possible_WCD.push_back(d);
            }
            while(s % d == 0) s /= d;            
        }        
    }
    if(f != 1) possible_WCD.push_back(f);
    if(s != 1) possible_WCD.push_back(s);
 
    bool possible = false;
    for(auto d : possible_WCD){
        bool correct = true;
        for(auto p : list){
            if(p.first % d != 0 && p.second % d != 0){
                correct = false;
                break;
            }
        }
        if(correct){
            cout<<d<<"\n";
            possible = true;
            break;
        }
    }
    if(!possible) cout<<(-1);
 
    return 0;
}