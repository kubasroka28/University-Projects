#include <iostream>
#include <vector>
#include <set>

#define ll long long

using namespace std;

void dijkstra(int x, vector<vector<pair<int, int>>>& graph, set<pair<ll, int>>& option_set, vector<ll>& shortest_path_length){
    for(auto neighbours : graph[x]){
        option_set.insert({shortest_path_length[x] + neighbours.first, neighbours.second});
    }

    if(!option_set.empty()){
        auto nearest = *option_set.begin();

        while(shortest_path_length[nearest.second] != -1){
            option_set.erase(nearest);
            if(!option_set.empty()){
                nearest = *option_set.begin();
            }
            else return;
        }

        shortest_path_length[nearest.second] = nearest.first;
        dijkstra(nearest.second, graph, option_set, shortest_path_length);
    }
    else return;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, m;
    cin>>n>>m;
    // first: edge weight, second: vertex number to which the edge is pointing
    vector<vector<pair<int, int>>> graph(n + 1);
    for(int i = 0; i < m; i++){
        int v, u, w;
        cin>>v>>u>>w;
        graph[v].push_back({w, u});
    }
    // first: distance from vertex number 1, second: number of the vertex we are measuring the distance from
    set<pair<ll, int>> option_set;
    vector<ll> shortest_path_length(n + 1, -1);
    shortest_path_length[1] = 0;

    dijkstra(1, graph, option_set, shortest_path_length);

    for(int i = 1; i <= n; i++){
        cout<<shortest_path_length[i]<<" ";
    }
    cout<<"\n";

    return 0;
}
