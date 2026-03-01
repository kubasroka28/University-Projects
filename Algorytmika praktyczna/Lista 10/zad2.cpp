#include <iostream>
#include <vector>
#include <algorithm>

#define ll long long

using namespace std;

void dfs(int v, vector<vector<int>>& graph, vector<int>& visited, vector<int>& result){
    visited[v] = 1;
    for(auto neighbour : graph[v]){
        if(visited[neighbour] != 1)
            dfs(neighbour, graph, visited, result);
    }
    result.push_back(v);
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, m;
    cin>>n>>m;
    vector<vector<int>> graph(n + 1);
    for(int i = 0; i < m; i++){
        int u, v;
        cin>>u>>v;
        graph[u].push_back(v);
    }

    vector<int> visited(n + 1, 0);
    vector<int> result;

    for(int i = 1; i <= n; i++){
        if(visited[i] == 0){
            dfs(i, graph, visited, result);
        }
    }

    reverse(result.begin(), result.end());
    for(auto nodes : result){
        cout<<nodes<<" ";
    }

    return 0;
}
