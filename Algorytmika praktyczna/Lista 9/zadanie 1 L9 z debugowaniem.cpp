//! Ten kod nie dziala do konca poprawnie, w wersji bez debugowanie jest dobre, zmiana jest w dijkstra, oraz int -> long long w option_set



#include <iostream>
#include <vector>
#include <set>

#define ll long long

using namespace std;

void dijkstra(int x, vector<vector<pair<int, int>>>& graph, set<pair<int, int>>& option_set, vector<ll>& shortest_path_length){
    for(auto neighbours : graph[x]){
        //debug
        cout<<"node "<<x<<" has neighbour: "<<neighbours.second<<" with distance: "<<neighbours.first<<"\n";

        //debug
        cout<<"therefor we add the option: ("<<shortest_path_length[x] + neighbours.first<<", "<<neighbours.second<<")\n";

        option_set.insert({shortest_path_length[x] + neighbours.first, neighbours.second});
    }

    vector<pair<int,int>> to_erase;

    for(auto options : option_set){

        //debug
        cout<<"we have an option: ("<<options.first<<", "<<options.second<<")\n";

        if(shortest_path_length[options.second] == -1){

            //debug
            cout<<"it was NOT visited yet so we do nothing with it\n";

        }
        else{

            //debug
            cout<<"it was visited so we add it to to_erase list: ("<<options.first<<", "<<options.second<<") is getting deleted\n";

            to_erase.push_back(options);
        }
    }

    for(auto options : to_erase){
        //debug
        cout<<"we erase: ("<<options.first<<", "<<options.second<<")\n";
        option_set.erase(options);
    }

    if(!option_set.empty()){
        auto nearest = *option_set.begin();

        //debug
        cout<<"We have options so we choose the best one: ("<<nearest.first<<", "<<nearest.second<<")\n";
        cout<<"and we set the shortest path length to it for: "<<nearest.first<<"\n";
        cout<<"and we go to it\n";

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
    set<pair<int, int>> option_set;
    vector<ll> shortest_path_length(n + 1, -1);
    shortest_path_length[1] = 0;

    dijkstra(1, graph, option_set, shortest_path_length);

    for(int i = 1; i <= n; i++){
        cout<<shortest_path_length[i]<<" ";
    }
    cout<<"\n";

    for(int i = 1; i <= n; i++){
        cout<<"node "<<i<<": ";
        for(auto elem : graph[i]){
            cout<<"("<<elem.first<<","<<elem.second<<") ";
        }
        cout<<"\n";
    }

    return 0;
}
