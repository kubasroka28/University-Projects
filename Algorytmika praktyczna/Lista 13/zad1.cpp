#include <iostream>
#include <vector>
using namespace std;

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    string t, p;
    cin>>t>>p;
    int n = (int)p.length();
    int m = (int)t.length();
    int l = n + 1 + m;
    string s = p + '#' + t;
    vector<int> lps(l, 0);
    for(int i = 1; i < l; i++){
        int j = lps[i - 1];
        while(j > 0 && s[j] != s[i])
            j = lps[j - 1];
        if(s[j] == s[i])
            j++;
        lps[i] = j;
    }

    int result = 0;
    for(int i = n + 1; i < l; i++)
        if(lps[i] == n)
            result++;
    cout<<result;

    return 0;
}
