#include <iostream>
using namespace std;
 
#define ll long long
 
//function calculates how many numbers divisible by x are there in range [l,r]
ll pom(ll l, ll r, int x){
    while(l % x != 0) l++;
    while((r + 1) % x != 0) r++;
    ll anwser = (r - l + 1) / x;
    return anwser;
}

int main(){
    int Tab1[4] = {2, 3, 5, 7};
    int Tab2[6] = {6, 10, 14, 15, 21, 35};
    int Tab3[4] = {30, 42, 70, 105};
    int Tab4[1] = {210};
    int t;
    cin>>t;
    for(int i = 0; i < t; i++){
        ll l, r;
        cin>>l>>r;
        ll anwser = r - l + 1;
        for(int n : Tab1){
            anwser -= pom(l, r, n);
        }
        for(int n : Tab2){
            anwser += pom(l, r, n);
        }
        for(int n : Tab3){
            anwser -= pom(l, r, n);
        }
        for(int n : Tab4){
            anwser += pom(l, r, n);
        }
        cout<<anwser<<"\n";
    }
 
    return 0;
}