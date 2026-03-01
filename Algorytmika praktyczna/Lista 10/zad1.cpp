#include <iostream>
#include <vector>
#include <queue>
#include <functional>

#define ll long long

using namespace std;

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, m;
    cin>>n>>m;
    vector<vector<int>> graph(n + 1);
    vector<int> parents_counter(n + 1, 0);
    for(int i = 0; i < m; i++){
        int u, v;
        cin>>u>>v;
        graph[u].push_back(v);
        parents_counter[v]++;
    }

    priority_queue<int, vector<int>, greater<int>> node_queue;
    for(int i = 1; i <= n; i++){
        if(parents_counter[i] == 0)
            node_queue.push(i);
    }

    vector<int> result;
    int impossible_flag = 0;
    for(int i = 0; i < n; i++){
        if(node_queue.empty()){
            impossible_flag = 1;
            break;
        }
        int smallest = node_queue.top();
        node_queue.pop();
        for(auto children : graph[smallest]){
            parents_counter[children]--;
            if(parents_counter[children] == 0)
                node_queue.push(children);
        }
        result.push_back(smallest);
    }

    if(impossible_flag){
        cout<<"IMPOSSIBLE";
    }
    else{
        for(auto nodes : result)
            cout<<nodes<<" ";
    }

    return 0;
}
