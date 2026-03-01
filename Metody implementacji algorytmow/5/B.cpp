//B. Jatayu's Balanced Bracket Sequence
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
        string s;
        cin>>n>>s;

        int depth[n]; //This tells us on which depth we are with contex
        for(int i = 0; i < n; i++){
            depth[i] = 0;
        }        
        int open_to_closed_brackets_balance = 0; //This tells us on which depth we are
        int anwser = 0;
        for(int i = 0; i < 2 * n; i++){
            if(s[i] == '('){
                //We are steping into this depth for the first time while being in a certain bracket pair
                if(depth[open_to_closed_brackets_balance] == 0){
                    anwser++;
                    depth[open_to_closed_brackets_balance] = 1;
                }

                open_to_closed_brackets_balance++;
            }
            else{
                depth[open_to_closed_brackets_balance] = 0;
                open_to_closed_brackets_balance--;
            } 
        }
        cout<<anwser<<"\n";
    }
    return 0;
}

//1 9 (()(()))()((()()))