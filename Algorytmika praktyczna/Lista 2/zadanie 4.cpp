//Jakub Sroka 11.03.2025

#include <iostream>
using namespace std;

struct result{
//lowest value, highest value, egdes counter
long long l, h, e;
} typedef res;

int find_set(int t, int parent[]){
    if (t != parent[t])
        parent[t] = find_set(parent[t], parent);
    return parent[t];
}

void union_set(int t1, int t2, int parent[], int subtree_size[], int lowest[], int highest[], long long edges[], res* w){
    t1 = find_set(t1, parent);
    t2 = find_set(t2, parent);

    if(t1 == t2){
        edges[t1] += 1;
    }
    else{
        if(subtree_size[t1] < subtree_size[t2]) swap(t1, t2);
        parent[t2] = t1;
        subtree_size[t1] += subtree_size[t2];
        lowest[t1] = min(lowest[t1], lowest[t2]);
        highest[t1] = max(highest[t1], highest[t2]);
        edges[t1] += edges[t2] + 1;
    }
    w->e = edges[t1];
    w->l = lowest[t1];
    w->h = highest[t1];
}

int main(){
    int N, M;
    cin>>N>>M;

    int parent[N+1], subtree_size[N+1], lowest[N+1], highest[N+1];
    long long edges[N+1];
    for(int i=1; i<=N; i++){
        parent[i] = i;
        subtree_size[i] = 1;
        lowest[i] = highest[i] = i;
        edges[i] = 0;
    }
    res results;

    for(int i=0; i<M; i++){
        int a, b;
        cin>>a>>b;
        union_set(a, b, parent, subtree_size, lowest, highest, edges, &results);
        cout<< (results.h - results.l) * results.e <<"\n";
    }
    return 0;
}
