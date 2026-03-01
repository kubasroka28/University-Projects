// Jakub Sroka 15.04.2025
// Zlozonosc obliczeniowa : O((N + Q) * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

typedef struct Tree_node{
    long long sum;
    long long max_pr_sum;
} tree_node;

tree_node rek(int b, int e, int x, int y, vector<tree_node>& tree){
    if(x == b && y == e){
        while(x != y){
            x /= 2;
            y /= 2;
        }
        return {tree[x].sum, max(tree[x].max_pr_sum, 0LL)};
    }
    else{
        int s = (b + e) / 2;
        if(x >= b && y <= s){
            return rek(b, s, x, y, tree);
        }
        else if(x > s && y <= e){
            return rek(s + 1, e, x, y, tree);
        }
        else{
            tree_node left = rek(b, s, x, s, tree);
            tree_node right = rek(s + 1, e, s + 1, y, tree);
            return {left.sum + right.sum, max (max(left.max_pr_sum, left.sum + right.max_pr_sum), 0LL)};
        }
    }
}

long long max_prefix_sum(int x, int y, vector<tree_node>& tree, int leafs){
    tree_node result = rek(leafs, leafs * 2 - 1, leafs - 1 + x, leafs - 1 + y, tree);
    return result.max_pr_sum;
}

void change_value(int k, int v, vector<tree_node>& tree, int leafs){
    int node = leafs - 1 + k;
    tree[node].sum = tree[node].max_pr_sum = v;
    node /= 2;
    while(node >= 1){
        tree[node].sum = tree[2 * node].sum + tree[2 * node + 1].sum;
        tree[node].max_pr_sum = max (max (tree[2 * node].max_pr_sum, tree[2 * node].sum + tree[2 * node + 1].max_pr_sum), 0LL);
        node /= 2;
    }
}

void preprocessing(vector<tree_node>& tree, int leafs){
    for(int i = leafs - 1; i >= 1; i--){
        tree[i].sum = tree[2 * i].sum + tree[2 * i + 1].sum;
        tree[i].max_pr_sum = max (max (tree[2 * i].max_pr_sum, tree[2 * i].sum + tree[2 * i + 1].max_pr_sum), 0LL);
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    int leafs = 1 << static_cast<int>(ceil(log2(n)));
    tree_node empty_node = {0, 0};
    vector<tree_node> tree (leafs * 2, empty_node);
    for(int i = 0; i < n; i++){
        int a;
        cin>>a;
        tree[leafs + i].sum = a;
        tree[leafs + i].max_pr_sum = max(a, 0);
    }
    preprocessing(tree, leafs);

    for(int i = 0; i < q; i++){
        int op_type;
        cin>>op_type;
        if(op_type == 1){
            int k, v;
            cin>>k>>v;
            change_value(k, v, tree, leafs);
        }
        else{
            int x, y;
            cin>>x>>y;
            cout<<max_prefix_sum(x, y, tree, leafs)<<"\n";
        }
    }

    return 0;
}



