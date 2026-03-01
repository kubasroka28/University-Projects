#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    string s;
    cin>>s;
    int n = (int)s.length();
    vector<int> lps(n, 0);
    for(int i = 1; i < n; i++){
        int j = lps[i - 1];
        while(j > 0 && s[j] != s[i])
            j = lps[j - 1];
        if(s[j] == s[i])
            j++;
        lps[i] = j;
    }

    for(int i = 0; i < n; i++)
        cout<<lps[i]<<" ";

    return 0;
}
