//A. Li Hua and Maze
#include <bits/stdc++.h>
using namespace std;
 
int test(int n, int m, int x, int y){
    if((x == 1 || x == n)){
        if(y == 1 || y == m) return 2;
        else return 3;
    }
    else if(y == 1 || y == m){
        return 3;
    } 
    return 4;
}

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);  
     
    int t;
    cin>>t;
    while(t--){
        int n, m;
        cin>>n>>m;
        int x1, y1, x2, y2;
        cin>>x1>>y1>>x2>>y2;

        int anwser = 4;
        anwser = min(anwser, test(n, m, x1, y1));
        anwser = min(anwser, test(n, m, x2, y2));
        cout<<anwser<<"\n";  
    }
    return 0;
}