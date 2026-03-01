// Jakub Sroka 01.04.2025
// Zlozonosc O(N), bo wykonuje sie jeden dfs

#include <iostream>
#include <vector>
using namespace std;

typedef struct dynamic_programming{
    // max including or excluding vertex
    int miv;
    int mev;
} dp;

void add_edge(int a, int b, vector<vector<int>>& tree){
    tree[a].push_back(b);
    tree[b].push_back(a);
}

void dfs(int vertex, int parent, vector<vector<int>>& tree, vector<dp>& DP){
    int lowest_miv_minus_mev = 1;

    for(int child : tree[vertex]){
        if (child == parent) continue;
        dfs(child, vertex, tree, DP);

        lowest_miv_minus_mev = min(lowest_miv_minus_mev, DP[child].miv - DP[child].mev);
        DP[vertex].mev += DP[child].miv;
    }

    DP[vertex].miv = DP[vertex].mev + (!lowest_miv_minus_mev);
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int N;
    cin>>N;
    vector<vector<int>> tree(N+1);
    for(int i=1; i<=N-1; i++){
        int a, b;
        cin>>a>>b;
        add_edge(a, b, tree);
    }
    vector<dp> DP(N+1, {0, 0});

    dfs(1, -1, tree, DP);
    cout<<DP[1].miv;

    return 0;
}
