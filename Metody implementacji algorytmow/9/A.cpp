//A. Students and Shoelaces
#include <bits/stdc++.h>
using namespace std;

//This function checks if there is a student tied to exactly one other student
bool check(int n, int degrees[]){
    for(int i = 0; i < n; i++){
        if(degrees[i] == 1) return true;
    }
    return false;
}

int main(){
    int n, m;
    cin>>n>>m;

    bool neighbours[n][n];
    for(int i = 0; i < n; i++){
        for(int j = 0; j < n; j++){
            neighbours[i][j] = 0;
        }
    }

    int degrees[n];
    for(int j = 0; j < n; j++){
        degrees[j] = 0;
    }

    for(int i = 0; i < m; i++){
        int a, b;
        cin>>a>>b;
        a--;
        b--;

        neighbours[a][b] = 1;
        neighbours[b][a] = 1;
        degrees[a]++;
        degrees[b]++;
    }

    int anwser = 0;
    while(check(n, degrees)){
        anwser++;
        //We create a list of pairs of students which Anna will reprimend and their neighbours
        vector<pair<int,int>> list;
        
        //For every student we check if he is tied to exactly one other student. If yes then we put him on the list along with his neighbour
        for(int i = 0; i < n; i++){
            if(degrees[i] == 1){
                for(int j = 0; j < n; j++){
                    if(neighbours[i][j] == 1){
                        list.push_back({i,j});
                        break;
                    }
                }                
            }
        }
        //For every student on the list we kick him out
        for(auto p : list){
            int f = p.first, s = p.second;
            if(neighbours[f][s] == 1){
                neighbours[f][s] = 0;
                neighbours[s][f] = 0;
                degrees[f]--;
                degrees[s]--;                  
            }     
        }
    }
    cout<<anwser;
}