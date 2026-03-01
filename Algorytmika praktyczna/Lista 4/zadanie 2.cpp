// Jakub Sroka
// Zlozonosc :

#include <iostream>
#include <vector>
using namespace std;

void preprocessing(){

}

int query_anwser(int a, int b, vector<vector<int>>& ){


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

    int log_of_numbers_to_n


    int floor_log_n = 0;
    for(int i = n; i > 1; i /= 2) floor_log_n++;
    vector<vector<int>> sparse_table(n, vector<int>(floor_log_n + 1));

    //lower_bound

    preprocessing(x, n, floor_log_n, sparse_table);

    for(int i = 0; i < q; i++){
        int a, b;
        cin>>a>>b;
        a--; b--;
        cout<<query_anwser(a, b, )<<"\n";
    }
    return 0;
}
