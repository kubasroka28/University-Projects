#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

typedef struct Node{
    int in;
    int out;
}node;

int LCA(int u, int v, int n, vector<vector<int>>& up, vector<node>& times){
    if(times[u].in <= times[v].in && times[u].out >= times[v].out) return u;
    if(times[v].in <= times[u].in && times[v].out >= times[u].out) return v;
    int k = log2(n);
    for(int i = k; i >= 0; i--){
        if(up[u][i] != -1){
            if (!(times[up[u][i]].in <= times[v].in && times[up[u][i]].out >= times[v].out))
                u = up[u][i];
        }
    }
    return up[u][0];
}

void dfs(int vertex, int parent, vector<int> tree[], vector<node>& in_out_times, vector<vector<int>>& up, int& counter, vector<int>& depth){
    if(vertex != 1){
        depth[vertex] = depth[parent] + 1;
        up[vertex][0] = parent;
    }
    in_out_times[vertex].in = ++counter;
    for(int child : tree[vertex]){
        if(child != parent){
            dfs(child, vertex, tree, in_out_times, up, counter, depth);
        }
    }
    in_out_times[vertex].out = ++counter;
}

void preprocessing(int n, vector<int> tree[], vector<vector<int>>& up, vector<node>& in_out_times, vector<int>& depth){
    // in&out times and parents in "up" preprocessing
    int counter = 0;
    dfs(1, -1, tree, in_out_times, up, counter, depth);
    // up preprocessing
    for(int k = 1; k <= log2(n); k++){
        for(int u = 1; u <= n; u++){
            if(up[u][k-1] != -1)
                up[u][k] = up[up[u][k-1]][k-1];
        }
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    vector<int> tree[n+1];
    for(int i = 0; i < n - 1; i++){
        int u, v;
        cin>>u>>v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }
    vector<vector<int>> up(n + 1, vector<int>(log2(n) + 1, -1));
    vector<node> in_out_times(n + 1);
    vector<int> depth(n + 1, 0);
    preprocessing(n, tree, up, in_out_times, depth);

//    write tree
    for (int i = 1; i <= n; ++i) {
        cout << "Wierzcholek " << i << ": ";
        for (int nei : tree[i]) {
            cout << nei << " ";
        }
        cout << "\n";
    }

// write up
    for(int k = 0; k <= log2(n); k++){
        for(int u = 1; u <= n; u++){
            cout<<up[u][k]<<" ";
        }
        cout<<"\n";
    }

// write in & out
    for(int i = 1; i <= n; i++){
        cout<<in_out_times[i].in<<" "<<in_out_times[i].out<<"\n";
    }

// write depth
    for(int i = 1; i <= n; i++){
        cout<<depth[i]<<"\n";
    }

//    for(int i = 0; i < q; i++){
//        int u, v;
//        cin>>u>>v;
//        int lca = LCA(u, v, n, up, in_out_times);
//        int result = depth[u] + depth[v] - 2 * depth[lca];
//        cout<<result<<"\n";
//    }

    return 0;
}

/*
11 1
1 2
1 3
2 4
2 5
3 6
3 7
7 8
7 9
9 10
10 11
*/

