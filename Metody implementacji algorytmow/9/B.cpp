//B. Om Nom and Dark Park
#include <bits/stdc++.h>
using namespace std;

int main(){
    int n, two_pow_n, two_pow_np1;
    cin>>n;
    two_pow_n = 1<<n;
    two_pow_np1 = two_pow_n<<1;
    
    //loading data and initializing the base level of array subpath_len
    int a[two_pow_np1];
    for(int i = 2; i < two_pow_np1; i++){
        cin>>a[i];
    }    
    int subpath_len[two_pow_np1];
    for(int i = two_pow_n; i < two_pow_np1; i++){
        subpath_len[i] = 0;
    }  

    //calculating the lenghts of subpaths and the amounts of light which have to be added
    int anwser = 0;
    for(int i = two_pow_n - 1; i >= 1; i--){
        int left = subpath_len[i*2] + a[i*2];
        int right = subpath_len[i*2 + 1] + a[i*2 + 1];
        int len_max = max(left, right);
        anwser += len_max - min(left, right);
        subpath_len[i] = len_max;
    }
    cout<<anwser;
}