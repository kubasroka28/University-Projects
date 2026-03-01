//B. King of Thieves
#include <bits/stdc++.h>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int n;
    string s;
    cin>>n>>s;
    bool good = false;

    for(int d = 0; d <= (n-5)/4; d++){//distance between i_k and i_k+1
        for(int b = 0; b <= n - (5 + 4 * d); b++){//beginging of a series of consecutive jumps
            bool check = true;
            for(int j = 0; j <= 4; j++){//checking every jump position
                int checking = b + j * (d + 1);
                if(s[checking] == '.'){
                    check = false;
                    break;
                } 
            }
            if(check){
                cout<<"yes";
                return 0;
            }
        }
    }
    cout<<"no";

    return 0;
}