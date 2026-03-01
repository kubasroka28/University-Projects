// Jakub Sroka 01.04.2025
// Zlozonosc O( 2^n * n^2 )

#include <iostream>
#include <vector>
using namespace std;

const int MOD = 1e9 + 7;

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int N, M;
    cin>>N>>M;

    vector<vector<int>> tree(N);
    for(int i = 0; i < M; i++){
        int a, b;
        cin>>a>>b;
        tree[a - 1].push_back(b - 1);
    }

    int scope = (1 << N);
    vector<vector<int>> DP(scope, vector<int>(N, 0));
    DP[1][0] = 1;

    for(int mask = 1; mask < scope; mask++){
        for(int v = 0; v < N; v++){
            if (!((1 << v) & mask)) continue;
            for(int u : tree[v]){
                if (((1 << u) & mask)) continue;
                DP[mask | (1 << u)][u] = (DP[mask | (1 << u)][u] + DP[mask][v]) % MOD;
            }
        }
    }

    cout<<DP[scope-1][N-1];

    return 0;
}
