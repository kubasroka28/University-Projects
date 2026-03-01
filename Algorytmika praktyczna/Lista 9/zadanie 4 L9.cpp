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

    int n, m;
    cin>>n>>m;
    vector<Edge> edges;
    for(int i = 0; i < m; i++){
        int u, v, w;
        cin>>u>>v>>w;
        edges.push_back({u, v, w});
    }
    vector<ll> DST(n + 1, 0);
    DST[1] = 0;
    vector<int> predecessor(n + 1, -1);
    int x = -1;

    for(int i = 0; i < n; i++){
        x = -1;
        for(auto edge : edges){
            if(DST[edge.u] + edge.w < DST[edge.v]){
                DST[edge.v] = DST[edge.u] + edge.w;
                predecessor[edge.v] = edge.u;
                x = edge.v;
            }
        }
    }

    if(x != -1){
        cout<<"YES\n";
        for(int i = 0; i < n; i++){
            x = predecessor[x];
        }
        vector<int> cycle;
        for(int i = x;; i = predecessor[i]){
            cycle.push_back(i);
            if(i == x && cycle.size() > 1) break;
        }
        for(int i = cycle.size(); i > 0; i--){
            cout<<cycle[i - 1]<<" ";
        }
    }
    else{
        cout<<"NO";
    }

    return 0;
}


