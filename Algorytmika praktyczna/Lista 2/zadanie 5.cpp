//Jakub Sroka 13.03.2025
// O((N + M) * alpha(n))

#include <iostream>

using namespace std;

int find_set(int t, int parent[], int path_parity_to_parent[]){
    if (t != parent[t])
    {
        int temp = parent[t];
        parent[t] = find_set(parent[t], parent, path_parity_to_parent);
        path_parity_to_parent[t] = (path_parity_to_parent[t] + path_parity_to_parent[temp]) % 2;
    }
    return parent[t];
}

bool union_set(int t1, int t2, int parity, int parent[], int subtree_size[], int path_parity_to_parent[]){
    int p1 = find_set(t1, parent, path_parity_to_parent);
    int p2 = find_set(t2, parent, path_parity_to_parent);

    if(p1 == p2){
        return ((path_parity_to_parent[t1] + path_parity_to_parent[t2]) % 2 == parity);
    }
    else{
        if(subtree_size[p1] < subtree_size[p2]) swap(p1, p2);
        parent[p2] = p1;
        subtree_size[p1] += subtree_size[p2];
        path_parity_to_parent[p2] = (path_parity_to_parent[t1] + path_parity_to_parent[t2] + parity) % 2;
        return true;
    }
}


int main(){
    int N, M;
    cin>>N>>M;

    int parent[N+1], subtree_size[N+1], path_parity_to_parent[N+1];
    for(int i=1; i<=N; i++){
        parent[i] = i;
        subtree_size[i] = 1;
        path_parity_to_parent[i] = 0;
    }

   int w=0;

    for(int i=0; i<M; i++){
        int a, b, p;
        cin>>a>>b>>p;
        if(union_set(a, b, p, parent, subtree_size, path_parity_to_parent)) w++;
        else{
            for(int j=i+1; j<M; j++) cin>>a>>b>>p;
            break;
        }
    }
    cout<<w;
    return 0;
}
