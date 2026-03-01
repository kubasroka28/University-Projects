#include <iostream>
using namespace std;

int main(){
    int t;
    cin>>t;
    for(int i = 0; i < t; i++){
        string s;
        cin>>s;
        int Ncounter = 0;
        for(char c : s){
            if(c == 'N') Ncounter++;
        }
        if(Ncounter == 1) cout<<"NO\n";
        else cout<<"YES\n";
    }
}