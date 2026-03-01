#include <iostream>
using namespace std;

int main(){
    int q;
    cin>>q;
    for(int i = 0; i < q; i++){
        string s, t;
        cin>>s>>t;
        bool is_possible;
        for(int b = 0; b < s.length(); b++){//beginning
            for(int m = b; m < s.length() && m < b + t.length(); m++){//middle
                int e = m - (t.length() - (m - b + 1));//end
                if(e < 0) continue;
                string new_string = "";
                for(int j = b; j <= m; j++){
                    new_string += s[j];
                }
                for(int j = m - 1; j >= e; j--){
                    new_string += s[j];
                }
                is_possible = true;
                for(int j = 0; j < t.length(); j++){
                    if(t[j] != new_string[j]){
                        is_possible = false;
                        break;
                    } 
                }
                if(is_possible) break;
            }
            if(is_possible) break;
        }
        if(is_possible) cout<<"YES\n";
        else cout<<"NO\n";
    }
}