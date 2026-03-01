// Jakub Sroka 17.04.2025
// Zlozonosc obliczeniowa : O((N + Q) * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

typedef struct Tree_node{
    long long max_sum;
    long long max_pr_sum;
    long long max_sf_sum;
    long long sum;
} tree_node;

void modify_node(int node, vector<tree_node>& tree){
    tree[node].max_sum = max(max(tree[2 * node].max_sum, tree[2 * node + 1].max_sum), tree[2 * node].max_sf_sum + tree[2 * node + 1].max_pr_sum);
    tree[node].max_pr_sum = max (max (tree[2 * node].max_pr_sum, tree[2 * node].sum + tree[2 * node + 1].max_pr_sum), 0LL);
    tree[node].max_sf_sum = max (max (tree[2 * node + 1].max_sf_sum, tree[2 * node + 1].sum + tree[2 * node].max_sf_sum), 0LL);
    tree[node].sum = tree[2 * node].sum + tree[2 * node + 1].sum;
}

void change_value(int k, int v, vector<tree_node>& tree, int leafs){
    int node = leafs - 1 + k;
    tree[node].max_sum = tree[node].max_pr_sum = tree[node].max_sf_sum = max(v, 0);
    tree[node].sum = v;
    node /= 2;
    while(node >= 1){
        modify_node(node, tree);
        node /= 2;
    }
}

void preprocessing(vector<tree_node>& tree, int leafs){
    for(int i = leafs - 1; i >= 1; i--){
        modify_node(i, tree);
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    int leafs = 1 << static_cast<int>(ceil(log2(n)));
    tree_node empty_node = {0, 0, 0, 0};
    vector<tree_node> tree (leafs * 2, empty_node);
    for(int i = 0; i < n; i++){
        int a;
        cin>>a;
        tree[leafs + i].sum = a;
        tree[leafs + i].max_sum = tree[leafs + i].max_pr_sum = tree[leafs + i].max_sf_sum = max(a, 0);
    }
    preprocessing(tree, leafs);

    for(int i = 0; i < q; i++){
        int k, x;
        cin>>k>>x;
        change_value(k, x, tree, leafs);
        cout<<tree[1].max_sum<<"\n";
    }

    return 0;
}




