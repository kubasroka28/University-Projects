// Jakub Sroka 18.03.2025
// Złożoność zapytania: O(sqrt(n))
// Złożoność preprocessingu: O(n*sqrt(n))

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

long long big_b_calculator(int a, int b, int n, vector<int>& x){
    long long sum = 0;
    for(int i = a; i <= n; i+=b){
        sum += x[i];
    }
    return sum;
}


void preprocessing(int n, int div_point, vector<int>& x, vector<vector<long long>>& precomputed){
    for(int b = 1; b <= div_point; b++){
        for(int a = n; a >= 1; a--){
            precomputed[a][b] = x[a];
            if(a + b <= n) precomputed[a][b] += precomputed[a + b][b];
        }
    }

//    for(int b = 1; b <= div_point; b++){
//        for(int a = 1; a <= b; a++){
//            for(int i = 0; a + i * b <= n; i++){
//                precomputed[a][b] += x[a + i * b];
//            }
//        }
//        for(int a = b + 1; a <= n; a++){
//            for(int i = 0; a + i * b <= n; i++){
//                precomputed[a][b] = precomputed[a - b][b] - x[a - b];
//            }
//        }
//    }
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n;
    cin>>n;
    vector<int> x(n+1, 0);
    for(int i=1; i<=n; i++){
        cin>>x[i];
    }
    // punkt dzielacy male i duze elementy
    int div_point = (int) sqrt(n) + 1;
    // sumy duzych elementow
    vector<vector<long long>> precomputed(n+1, vector<long long>(div_point+1, 0));
    preprocessing(n, div_point, x, precomputed);

    int q;
    cin>>q;
    for(int i=0; i<q; i++){
        int a, b;
        cin>>a>>b;
        long long result;
        if(b <= div_point){
            result = precomputed[a][b];
        }
        else{
            result = big_b_calculator(a, b, n, x);
        }
        cout<<result<<"\n";
    }
    return 0;
}

