#include <iostream>
#include <vector>
#include <set>

#define ll long long
#define INF 25e11

using namespace std;

struct Edge{
    int u, v, w;
};

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, m, q;
    cin>>n>>m>>q;
    vector<Edge> edges;
    vector<vector<ll>> DST(n + 1, vector(n + 1, INF));

    for(int i = 0; i < m; i++){
        int u, v, w;
        cin>>u>>v>>w;
        DST[u][v] = min(w, DST[u][v]);
        DST[v][u] = min(w, DST[v][u]);
    }

    for(int k = 0; k < n; k++){
        for(int j = 0; j < n; j++){
            for(int i = 0; i < n; i++){
                if(DST)
            }
        }
    }

    return 0;
}



