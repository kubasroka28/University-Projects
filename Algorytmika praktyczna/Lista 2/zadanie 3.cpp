//Jakub Sroka 09.03.2025
// O(M * alpha(n))

#include <iostream>

using namespace std;

struct result{
//connected_grahps_counter
int cgc;
//biggest_connected_graph
int bcg;
} typedef res;

int find_set(int t, int parent[]){
    if (t != parent[t])
        parent[t] = find_set(parent[t], parent);
    return parent[t];
}

void union_set(int t1, int t2, int parent[], int subtree_size[], res* w){
    int p1, p2;
    p1 = find_set(t1, parent);
    p2 = find_set(t2, parent);
    if(p1 == p2) return;

    if(subtree_size[p1] >= subtree_size[p2]){
        parent[p2] = p1;
        subtree_size[p1] += subtree_size[p2];
        w->bcg = max(w->bcg, subtree_size[p1]);
    }
    else{
        parent[p1] = p2;
        subtree_size[p2] += subtree_size[p1];
        w->bcg = max(w->bcg, subtree_size[p2]);
    }
    w->cgc--;
}

int main(){
    int N, M;
    cin>>N>>M;

    int parent[N+1];
    for(int i=1; i<=N; i++) parent[i] = i;
    int subtree_size[N+1];
    for(int i=1; i<=N; i++) subtree_size[i] = 1;

    res results;
    results.cgc = N;
    results.bcg = 1;

    for(int i=0; i<M; i++){
        int t1, t2;
        cin>>t1>>t2;
        union_set(t1, t2, parent, subtree_size, &results);
        cout<<results.cgc<<" "<<results.bcg<<"\n";
    }
    return 0;
}

