#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

typedef struct Node{
    int first;
    int last;
}node;

void dfs(int vertex, int parent, vector<int> tree[], vector<int>& values, vector<int>& eulers_tour, vector<int>& values_on_tour){
    eulers_tour.push_back(vertex);
    values_on_tour.push_back(values[vertex]);
    for(int child : tree[vertex]){
        if(child != parent){
            dfs(child, vertex, tree, values, eulers_tour, values_on_tour);
            eulers_tour.push_back(vertex);
            values_on_tour.push_back(0);
        }
    }
}

void preprocessing(vector<int> tree[], vector<int>& values, vector<int>& eulers_tour, vector<int>& values_on_tour, vector<node>& occurences){
    dfs(1, -1, tree, values, eulers_tour, values_on_tour);
    for(int i = 0; i < eulers_tour.size(); i++){
        if(occurences[eulers_tour[i]].first == -1) occurences[eulers_tour[i]].first = i + 1;
        occurences[eulers_tour[i]].last = i + 1;
    }
}

void tree_preprocessing(int n, int leaf_counter, vector<long long>& segment_tree, vector<int>& values_on_tour){
    for(int i = 0; i < n; i++){
        segment_tree[leaf_counter + i] = values_on_tour[i];
    }
    for(int i = leaf_counter - 1; i >= 1; i--){
        segment_tree[i] = segment_tree[2 * i] + segment_tree[2 * i + 1];
    }
}

long long prefix_sum(int k, vector<long long>& segment_tree, int leaf_counter){
    if(k == 0) return 0;
    int node = leaf_counter - 1 + k;
    long long pr_sum = segment_tree[node];
    while(node > 1){
        if(node % 2 == 1){
            pr_sum += segment_tree[node - 1];
        }
        node /= 2;
    }
    return pr_sum;
}

void change(int k, int x,  vector<long long>& segment_tree, int leaf_counter){
    int node = leaf_counter - 1 + k;
    int old_val = segment_tree[node];
    while(node >= 1){
        segment_tree[node] += x - old_val;
        node /= 2;
    }
}

long long query(int v, vector<long long>& segment_tree, int leaf_counter, vector<node>& occurences){
    return prefix_sum(occurences[v].last, segment_tree, leaf_counter) - prefix_sum(occurences[v].first - 1, segment_tree, leaf_counter);
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    vector<int> values(n + 1, 0);
    for(int i = 1; i <= n; i++){
        cin>>values[i];
    }
    vector<int> tree[n+1];
    for(int i = 0; i < n - 1; i++){
        int u, v;
        cin>>u>>v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }
    vector<int> eulers_tour(0);
    vector<int> values_on_tour(0);
    vector<node> occurences(n + 1, {-1, -1});
    preprocessing(tree, values, eulers_tour, values_on_tour, occurences);
    int leaf_counter = 1 << static_cast<int>(ceil(log2(eulers_tour.size())));
    vector<long long> segment_tree(leaf_counter * 2, 0);
    tree_preprocessing(eulers_tour.size(), leaf_counter, segment_tree, values_on_tour);

//    for (int x : eulers_tour) {
//        cout << x << " ";
//    }
//    cout<<"\n";
//    for (int x : values_on_tour) {
//        cout << x << " ";
//    }
//    cout<<"\n";
//    cout<<eulers_tour.size()<<"\n";
//    for (int i = 1; i <= n; i++){
//        cout <<occurences[i].first<<" "<<occurences[i].last<<"\n";;
//    }
//    for (int i = 1; i <= leaf_counter * 2 - 1; i++){
//        cout<<segment_tree[i]<<" ";
//    }
//    cout<<"\n";

    for(int i = 0; i < q; i++){
        int op_type;
        cin>>op_type;
        if(op_type == 1){
            int v, x;
            cin>>v>>x;
            change(occurences[v].first, x, segment_tree, leaf_counter);
        }
        else{
            int v;
            cin>>v;
            cout<<query(v, segment_tree, leaf_counter, occurences)<<"\n";
        }
    }

    return 0;
}


