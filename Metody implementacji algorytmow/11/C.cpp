//C. Almost Arithmetic Progression
#include <bits/stdc++.h>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int n;
    cin>>n;
    vector<int> b(n);
    for(int i = 0; i < n; i++){
        cin>>b[i];
    }
    if(n == 0 || n == 1){
        cout<<0;
        return 0;
    }

    // Analyzing the problem
    bool possible = false;
    int min_change = n + 1;
    // There are 9 possible beginnings to the sequnence
    for(int f = -1; f <= 1; f++){
        for(int s = -1; s <= 1; s++){
            // Preparing the beginning of the sequence
            vector<int> modified_b = b;
            modified_b[0] = b[0] + f;
            modified_b[1] = b[1] + s;
            int d = modified_b[1] - modified_b[0];

            // Analyzing the sequence
            bool seq_possible = true;
            int required_changes = abs(f) + abs(s);
            for(int j = 1; j < n - 1; j++){
                int diff = (modified_b[j+1] - modified_b[j]) - d;
                if(diff == 0) continue;
                else if(diff == 1){
                    modified_b[j+1] -= 1;
                    required_changes++;
                }
                else if(diff == -1){
                    modified_b[j+1] += 1;
                    required_changes++;
                }
                else{
                    seq_possible = false;
                    break;
                }
            }
            if(seq_possible){
                possible = true;
                min_change = min(min_change, required_changes);
            }            
        }
    }

    // Output
    if(possible) cout<<min_change<<"\n";
    else cout<<(-1)<<"\n";

    return 0;
}