#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

typedef struct Node{
    int in;
    int out;
}node;

void dfs(int vertex, int parent, vector<int> tree[], vector<node>& in_out_times, int& counter){
    in_out_times[vertex].in = ++counter;
    for(int child : tree[vertex]){
        if(child != parent){
            dfs(child, vertex, tree, in_out_times, counter);
        }
    }
    in_out_times[vertex].out = ++counter;
}

void preprocessing(int n, vector<vector<int>>& up, vector<node>& in_out_times){
    // up preprocessing
    for(int k = 1; k <= log2(n); k++){
        for(int u = 1; u <= n; u++){
            if(up[u][k-1] != -1)
                up[u][k] = up[up[u][k-1]][k-1];
        }
    }
    // in & out times preprocessing
    vector<int> tree[n+1];
    for(int i = 2; i <= n; i++){
        tree[i].push_back(up[i][0]);
        tree[up[i][0]].push_back(i);
    }
    int counter = 0;
    dfs(1, -1, tree, in_out_times, counter);

//    write in & out
//    for(int i = 1; i <= n; i++){
//        cout<<in_out_times[i].in<<" "<<in_out_times[i].out<<"\n";
//    }

//    write tree
//    for (int i = 1; i <= n; ++i) {
//        cout << "Wierzcholek " << i << ": ";
//        for (int nei : tree[i]) {
//            cout << nei << " ";
//        }
//        cout << "\n";
//    }
}

int ansestor(int v, int k, vector<vector<int>>& up){
    while(k != 0){
        v = up[v][log2(k)];
        if (v == -1) return -1;
        k -= 1 << static_cast<int>(log2(k));
    }
    return v;
}

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

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    vector<vector<int>> up(n + 1, vector<int>(log2(n) + 1, -1));
    for(int i = 2; i <= n; i++){
        cin>>up[i][0];
    }
    vector<node> in_out_times(n + 1);
    preprocessing(n, up, in_out_times);

//// write up
//    for(int k = 0; k <= log2(n); k++){
//        for(int u = 1; u <= n; u++){
//            cout<<up[u][k]<<" ";
//        }
//        cout<<"\n";
//    }
//
//
//// write in & out
//    for(int i = 1; i <= n; i++){
//        cout<<in_out_times[i].in<<" "<<in_out_times[i].out<<"\n";
//    }

    for(int i = 0; i < q; i++){
        int u, v;
        cin>>u>>v;
        cout<<LCA(u, v, n, up, in_out_times)<<"\n";
    }

    return 0;
}

/*
11 1
1 1 2 2 3 3 7 7 9 10
*/
