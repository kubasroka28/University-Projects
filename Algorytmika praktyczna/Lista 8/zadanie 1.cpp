#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

void preprocessing(int n, vector<vector<int>>& up){
    for(int k = 1; k <= log2(n); k++){
        for(int u = 1; u <= n; u++){
            if(up[u][k-1] != -1)
                up[u][k] = up[up[u][k-1]][k-1];
        }
    }
}

int query(int v, int k, vector<vector<int>>& up){
    while(k != 0){
        v = up[v][log2(k)];
        if (v == -1) return -1;
        k -= 1 << static_cast<int>(log2(k));
    }
    return v;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    vector<vector<int>> up(n+1, vector<int>(log2(n) + 1, -1));
    for(int i = 2; i <= n; i++){
        cin>>up[i][0];
    }
    preprocessing(n, up);

    for(int i = 0; i < q; i++){
        int v, k;
        cin>>v>>k;
        cout<<query(v, k, up)<<"\n";
    }

//    for(int k = 0; k <= log2(n); k++){
//        for(int u = 1; u <= n; u++){
//            cout<<up[u][k]<<" ";
//        }
//        cout<<"\n";
//    }

    return 0;
}

/*
11 1
1 1 2 2 3 3 7 7 9 10
*/
