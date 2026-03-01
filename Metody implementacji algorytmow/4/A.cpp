#include <iostream>
using namespace std;
 
int main(){
    int t;
    cin>>t;
    for(int i = 0; i < t; i++){
        int n;
        cin>>n;
        string s;
        cin>>s;
        int anwser = 0;
        int is_zero_before_one_flag = 1;
        for(int j = 0; j < s.length(); j++){
            if(s[j] == '1'){
                if(is_zero_before_one_flag) anwser += 2;
                is_zero_before_one_flag = 0;
            }
            else is_zero_before_one_flag = 1;
        }
        if(s[s.length() - 1] == '1') anwser--;
        cout<<anwser<<endl;
    }
    return 0;
}