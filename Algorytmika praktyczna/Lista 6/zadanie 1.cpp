// Jakub Sroka 13.04.2025
// Zlozonosc obliczeniowa : O(M + N * log(M))

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

int calculate(int k, vector<int>& tree, int leafs){
    int node = leafs + k;
    int prefix_sum = tree[node];
    while(node > 1){
        if(node % 2 == 1){
            prefix_sum += tree[node - 1];
        }
        node /= 2;
    }
    return prefix_sum;
}

void add(int k, vector<int>& tree, int leafs){
    int node = leafs + k;
    while(node >= 1){
        tree[node]++;
        node /= 2;
    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n;
    cin>>n;
    int leafs = 1 << static_cast<int>(ceil(log2(1e6 + 1)));
    vector<int> tree (leafs * 2, 0);
    long long inversions_counter = 0;

    for(int i = 0; i < n; i++){
        int a;
        cin>>a;
        add(a, tree, leafs);
        inversions_counter += tree[1] - calculate(a, tree, leafs);
    }
    cout<<inversions_counter;

    return 0;
}

