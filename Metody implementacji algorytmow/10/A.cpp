//A. Basketball Together
#include <bits/stdc++.h>
using namespace std;

int main(){
    int t = 1;
    while(t--){
        int N, D;
        cin>>N>>D;
        vector<int> P(N);
        for(int i = 0; i < N; i++){
            cin>>P[i];
        }
        sort(P.begin(), P.end());

        int Nhelp = N;
        int anwser = 0;
        while(Nhelp > 0){
            Nhelp -= D/P[N-1-anwser] + 1;
            if(Nhelp >= 0)  anwser++;    
        }
        cout<<anwser;
    }
    return 0;
}