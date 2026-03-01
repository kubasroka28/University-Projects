//A. Perfect Squares
#include <bits/stdc++.h>
using namespace std;
#define ten_pow6 1000001
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int n;
    cin>>n;
    bool is_sq[ten_pow6];
    for(int i = 0; i < ten_pow6; i++){
        is_sq[i] = false;
    }
    for(int i = 0; i < 1001; i++){
        is_sq[i * i] = true;
    }
 
    int anwser = -1000001;
    for(int i = 0; i < n; i++){
        int a;
        cin>>a;
        
        if(a < 0 || !is_sq[a]) anwser = max(anwser, a);
    }
    cout<<anwser;
    return 0;
}