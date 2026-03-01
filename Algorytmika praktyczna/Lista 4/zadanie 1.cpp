// Jakub Sroka 25.03.2025
// Zlozonosc : O( (N + Q) * logN )

#include <iostream>
#include <vector>
using namespace std;

void preprocessing(vector<int>& x, int n, int floor_log_n, vector<vector<int>>& sparse_table){
    for(int i = 0; i < n; i++){
        sparse_table[i][0] = x[i];
    }
    int two_to_the_power_of_j = 1;
    for(int j = 1; j <= floor_log_n; j++){
        two_to_the_power_of_j *= 2;
        for(int i = 0; i + two_to_the_power_of_j - 1 < n; i++){
            sparse_table[i][j] = min(sparse_table[i][j - 1], sparse_table[(i + i + two_to_the_power_of_j - 1) / 2 + 1][j - 1]);
        }
    }
}

int query_anwser(int a, int b, vector<vector<int>>& sparse_table){
    int max_j = 0;
    int two_to_the_power_of_max_j = 1;
    for(int i = b - a + 1; i > 1; i /= 2){
        max_j++;
        two_to_the_power_of_max_j *= 2;
    }

    int anwser = min(sparse_table[a][max_j], sparse_table[b - two_to_the_power_of_max_j + 1][max_j]);

    return anwser;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n, q;
    cin>>n>>q;
    vector<int> x(n);
    for(int i=0; i<n; i++){
        cin>>x[i];
    }
    int floor_log_n = 0;
    for(int i = n; i > 1; i /= 2) floor_log_n++;
    vector<vector<int>> sparse_table(n, vector<int>(floor_log_n + 1));

    preprocessing(x, n, floor_log_n, sparse_table);

//    int two_to_the_power_of_j = 1;
//    for(int i = 0; i <n; i++){
//        cout<<sparse_table[i][0]<<" ";
//    }
//    cout<<"\n";
//    for(int j = 1; j <= floor_log_n; j++){
//        two_to_the_power_of_j *= 2;
//        for(int i = 0; i + two_to_the_power_of_j - 1 < n; i++){
//            cout<<sparse_table[i][j]<<" ";
//        }
//        cout<<"\n";
//    }

    for(int i = 0; i < q; i++){
        int a, b;
        cin>>a>>b;
        a--; b--;
        cout<<query_anwser(a, b, sparse_table)<<"\n";
    }
    return 0;
}
