// Jakub Sroka 31.03.2025
// Zlozonosc O(N), bo wykonuje sie jeden dfs

#include <iostream>
#include <vector>
using namespace std;

typedef struct dynamic_programming{
    int MAX_SR;
    int W;
} dp;

void add_edge(int a, int b, vector<vector<int>>& tree){
    tree[a].push_back(b);
    tree[b].push_back(a);
}

void dfs(int vertex, int parent, vector<vector<int>>& tree, vector<dp>& DP){
    int max_sr = 0, fst_max_w = -1, snd_max_w = -1;

    for(int child : tree[vertex]){
        if(child != parent){
            dfs(child, vertex, tree, DP);
            max_sr = max(max_sr, DP[child].MAX_SR);

            if (DP[child].W > fst_max_w) {
                snd_max_w = fst_max_w;
                fst_max_w = DP[child].W;
            } else if (DP[child].W > snd_max_w) {
                snd_max_w = DP[child].W;
            }

        }
    }

    DP[vertex].MAX_SR = max(max_sr, fst_max_w + snd_max_w + 2);
    DP[vertex].W = fst_max_w + 1;
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
    cout<<DP[1].MAX_SR;

    return 0;
}
