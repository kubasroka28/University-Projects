// Jakub Sroka 15.04.2025
// Zlozonosc obliczeniowa : O((N + Q) * log N)

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

void rek(int b, int e, int x, int y, int v, vector<long long>& tree){
    if(x == b && y == e){
        while(x != y){
            x /= 2;
            y /= 2;
        }
        tree[x] += v;
    }
    else{
        int s = (b + e) / 2;
        if(x >= b && y <= s){
            rek(b, s, x, y, v, tree);
        }
        else if(x > s && y <= e){
            rek(s + 1, e, x, y, v, tree);
        }
        else{
            rek(b, s, x, s, v, tree);
            rek(s + 1, e, s + 1, y, v, tree);
        }
    }
}

void increase(int x, int y, int v, vector<long long>& tree, int leafs){
    rek(leafs, leafs * 2 - 1, leafs - 1 + x, leafs - 1 + y, v, tree);
}

long long value(int k, vector<long long>& tree, int leafs){
    int node = leafs - 1 + k;
    long long result = 0;
    while(node >= 1){
        result += tree[node];
        node /= 2;
    }
    return result;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    vector<int> A(n);
    for(int i = 0; i < n; i++){
        cin>>A[i];
    }
    int leafs = 1 << static_cast<int>(ceil(log2(n)));
    vector<long long> tree (leafs * 2, 0);
    for(int i = 0; i < leafs; i++){
        tree[leafs + i] = A[i];
    }

    for(int i = 0; i < q; i++){
        int op_type;
        cin>>op_type;
        if(op_type == 1){
            int x, y, v;
            cin>>x>>y>>v;
            increase(x, y, v, tree, leafs);
        }
        else{
            int k;
            cin>>k;
            cout<<value(k, tree, leafs)<<"\n";
        }
    }

    return 0;
}


