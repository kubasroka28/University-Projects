// Jakub Sroka 11.03.2025
// O(n logn) (kazdy elemement bedzie skopiowany maksymalnie logn razy dzieki temu, ze dodajemy mniejszy do wiekszego)

#include <iostream>
#include <vector>
#include <unordered_set>
using namespace std;

void add_edge(int a, int b, vector<int> tree[]){
    tree[a].push_back(b);
    tree[b].push_back(a);
}

void add_set(unordered_set<int>& parent, unordered_set<int>& child){
    if(child.size() > parent.size()){
        swap(parent, child);
    }
    for(int x : child) parent.insert(x);
}

void dfs(int vertex, int parent, vector<int> tree[], vector<unordered_set<int>>& colours, vector<int>& results){
    for(int child : tree[vertex]){
        if(child != parent){
            dfs(child, vertex, tree, colours, results);
            add_set(colours[vertex], colours[child]);
        }
    }
    results[vertex] = colours[vertex].size();
}

int main(){
    int N;
    cin>>N;
    vector<int> tree[N+1];
    vector<unordered_set<int>> colours(N+1);
    vector<int> results(N+1);

    for(int i=1; i<=N; i++){
        int c;
        cin>>c;
        colours[i].insert(c);
    }

    for(int i=1; i<=N-1; i++){
        int a, b;
        cin>>a>>b;
        add_edge(a, b, tree);
    }

    dfs(1, -1, tree, colours, results);

    for(int i=1; i<=N; i++){
        cout<<results[i]<<" ";
    }

    return 0;
}



// Jakub Sroka 11.03.2025

//usunac visited, to jest drzewo, a nie graf, wiec nie ma cykili. Wystarczy, ze pomine rodzica w petli i do argumentow dfs dodam parenta, zeby moc go pominac
//

//#include <iostream>
//#include <vector>
//#include <unordered_set>
//using namespace std;
//
//void add_edge(int a, int b, vector<int> tree[]){
//    tree[a].push_back(b);
//    tree[b].push_back(a);
//}
//
//void add_set(unordered_set<int>& parent, const unordered_set<int>& child){
//    for(int x : child) parent.insert(x);
//}
//
//void dfs(int vertex, vector<int> tree[], vector<bool>& visited, vector<unordered_set<int>>& colours){
//    visited[vertex] = true;
//    for(int neighbours : tree[vertex]){
//        if(!visited[neighbours]){
//            dfs(neighbours, tree, visited, colours);
//            add_set(colours[vertex], colours[neighbours]);
//        }
//    }
//}
//
//int main(){
//    int N;
//    cin>>N;
//    vector<int> tree[N+1];
//    vector<bool> visited(N+1, false);
//    vector<unordered_set<int>> colours(N+1);
//
//    for(int i=1; i<=N; i++){
//        int c;
//        cin>>c;
//        colours[i].insert(c);
//    }
//
//    for(int i=1; i<=N-1; i++){
//        int a, b;
//        cin>>a>>b;
//        add_edge(a, b, tree);
//    }
//
//    dfs(1, tree, visited, colours);
//
//    for(int i=1; i<=N; i++){
//        cout<<colours[i].size()<<" ";
//    }
//
//    return 0;
//}



///////////////////// wersja podobna do chata z globalnymi, niedokonczona
// Jakub Sroka 11.03.2025

//#include <iostream>
//#include <vector>
//#include <unordered_set>
//using namespace std;
//
//const int max_n = 200000;
//vector<int> tree[max_n+1];
//vector<int> results(max_n+1);
//vector<int> colours(max_n+1);
//
//void add_edge(int a, int b){
//    tree[a].push_back(b);
//    tree[b].push_back(a);
//}
//
//void dfs(int vertex, int parent){
//    for(int children : tree[vertex]){
//        if(children != parent){
//            unordered_set<int> new_set()
//            dfs(children, tree, visited, colours);
//            add_set(colours[vertex], colours[children]);
//        }
//    }
//}
//
//int main(){
//    int N;
//    cin>>N;
//
//    for(int i=1; i<=N; i++){
//        cin>>colours[i];
//    }
//
//    for(int i=1; i<=N-1; i++){
//        int a, b;
//        cin>>a>>b;
//        add_edge(a, b);
//    }
//
//    dfs(1);
//
//    for(int i=1; i<=N; i++){
//        cout<<results[i]<<" ";
//    }
//
//    return 0;
//}
