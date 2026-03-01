//B. Division by Two and Permutation
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
        cin>>n;
        
        //says wether number i from [1, n] is completed
        int comp[n + 1];
        for(int i = 0; i < n + 1; i++){
            comp[i] = 0;
        }
        //says how many numbers from [1,n] are missing
        int missing = n;    
        //colects numbers which are out of [1,n] or in [1,n] but already complete
        vector<int> bad_num;

        int a[n];
        for(int i = 0; i < n; i++){
            cin>>a[i];
            if(a[i] > n) bad_num.push_back(a[i]);
            else if(comp[a[i]] == 1) bad_num.push_back(a[i]);
            else{
                comp[a[i]] = 1;
                missing--;
            } 
        }

        for(int b : bad_num){
            //I take a bad number and divide it by two until it's in [1,n]
            //Then if it becomes a number which is not completed, I mark that this number is now completed, I lower missing counter and move on to the next bad number
            while(b != 1){
                b /= 2;
                if(b == 1) break;//If b becomes one then I check special things belowe the while loop
                if(b <= n){
                    if(comp[b] == 0){
                        comp[b] = 1;
                        missing--;
                        break;
                    }
                }                    
            }
            if(b == 1){
                //If b became 1 then it's either the first 1 and I can mark 1 as completed, lower missing counter and move on
                if(comp[1] == 0){
                    comp[1] = 1;
                    missing--;                    
                }
                //Or if b is another 1 then that means it wasn't able to complete one of the missing numbers and so the task is impossible
                else{
                    cout<<"NO\n";
                    break;
                }                
            }
        }
        //After going trough all bad numbers if nothing is missing then we have completed the task
        if(missing == 0) cout<<"YES\n";
    }
    return 0;
}