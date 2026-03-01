//C. Queries for Number of Palindromes
#include <bits/stdc++.h>
using namespace std;
 
/*
I will use a recursive relationship between the amount of palindromes in a substring and it's substrings

DP[l][r] = DP[l][r-1] + DP[l+1][r] - DP[l+1][r-1] + Pal[l][r];
Every palindrome in s[l...r-1] is in s[l...r]
Every palindrome in s[l+1...r] is in s[l...r]
Adding those two amounts causes counting palindromes from s[l+1...r-1] twice
The whole s[l...r] can also be a palindrome

Time complexity of this algorithm is O(n^2) because we consider every substring of s and perform a constant amount of calculations
*/

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    string s;
    cin>>s;
    int slen = s.length();
    vector<vector<int>> DP(slen, vector<int> (slen, 0));//DP[l][r] - the amount of palindromes in substring s[l...r]
    vector<vector<bool>> Pal(slen, vector<bool> (slen, false));//Pal[l][r] - boolean value saying wether s[l...r] is a palindrome

    //I calculate values of the whole DP table
    for(int d = 0; d < slen; d++){//d - the distance between left and right ends of a substring s[l...r]
        for(int l = 0; l + d < slen; l++){//l - the begining of a substring s[l...r]
            int r = l + d;//r - the end of a substring s[l...r]
            if(d == 0){//a single character is a palindrom
                DP[l][r] = 1;
                Pal[l][r] = true;
            }
            else{//we use a recursive relationship between values of DP
                if(d == 1){
                    Pal[l][r] = (s[l] == s[r]);
                }
                else{
                    Pal[l][r] = Pal[l+1][r-1] && (s[l] == s[r]);
                }
                DP[l][r] = DP[l][r-1] + DP[l+1][r] - DP[l+1][r-1] + Pal[l][r];
            }
        }
    }

    //I anwser the queries
    int q;
    cin>>q;
    for(int i = 0; i < q; i++){
        int l, r;
        cin>>l>>r;
        //I adjust the input to my structure
        l--;
        r--;
        cout<<DP[l][r]<<"\n";
    }
    return 0;
}