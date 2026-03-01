//C. Minimum path
#include <bits/stdc++.h>
using namespace std;

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL); 
    
    int n, k;
    cin>>n>>k;

    char matrix[n][n];
    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            cin>>matrix[i][j];
        }
    }

    int dp[n][n];
    int d = -1;
    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            if(i == 0 && j == 0){
                if(matrix[i][j] == 'a'){
                    dp[i][j] = 0;
                }
                else{
                    dp[i][j] = 1;
                }
            }
            else if(i == 0){
                if(matrix[i][j] == 'a'){
                    dp[i][j] = dp[i][j-1] + 0;
                }
                else{
                    dp[i][j] = dp[i][j-1] + 1;
                }                
            }
            else if(j == 0){
                if(matrix[i][j] == 'a'){
                    dp[i][j] = dp[i-1][j] + 0;
                }
                else{
                    dp[i][j] = dp[i-1][j] + 1;
                }                
            }
            else{
                if(matrix[i][j] == 'a'){
                    dp[i][j] = min(dp[i][j-1], dp[i-1][j]) + 0;
                }
                else{
                    dp[i][j] = min(dp[i][j-1], dp[i-1][j]) + 1;
                }                
            }
            if(dp[i][j] <= k) d = max(d, i + j);
        }
    }  
    
    string anwser = "";
    vector<bool> current_position(n, false);
    int start_step = 0;
    if(d == -1){
        anwser += matrix[0][0];
        current_position[0] = true;
        start_step = 0;
    }
    else{
        for(int i = 0; i < d+1; i++){
            anwser += 'a';
        }
        for(int i = 0; i < n; i++){
            int j = d - i;
            if(j >= 0 && j < n){
                if(dp[i][j] <= k){
                    current_position[i] = true;
                }                
            }
        }
        start_step = d;      
    }

    for(int step = start_step; step < 2*n-2; step++){
        vector<bool> next_position(n, 0);   
        char best_char = 'z' + 1;
        for(int i = 0; i < n; i++){
            if(current_position[i]){
                int j = step - i;
                if(i < n-1){
                    best_char = min(best_char, matrix[i+1][j]);
                }
                if(j < n-1){
                    best_char = min(best_char, matrix[i][j+1]);
                }                
            }
        }
        for(int i = 0; i < n; i++){
            if(current_position[i]){
                int j = step - i;
                if(i < n-1){
                    if(matrix[i+1][j] == best_char){
                        next_position[i+1] = true;
                    }
                }
                if(j < n-1){
                    if(matrix[i][j+1] == best_char){
                        next_position[i] = true;
                    }
                }                 
            }
        }        
        
        anwser += best_char;
        current_position = next_position;
    }

    cout<<anwser<<"\n";

    return 0;
}