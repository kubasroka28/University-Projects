// Jakub Sroka 18.03.2025

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

long long count_sum(int l, int r, vector<int>& x, int s, vector<long long>& b){
    long long  sum = 0;
    int bl = ((l - 1) / s), br = ((r - 1) / s);

    //jesli przedzial znajduje sie w srodku bloku to obliczamy sume standardowo
    if(bl == br){
        for(int i = l; i <= r; i++)
            sum += x[i];
    }
    else{
        //doliczamy do sumy pojedyncze elementy dopoki jestesmy w tym samym bloku co l
        for(int i = l; i < (bl + 1) * s + 1 ; i++){
            sum += x[i];
        }
        //doliczamy do sumy wyliczone wczesniej sumy blokow dopoki jestesmy przed blokiem z r
        for(int i = bl + 1; i < br; i++)
        {
            sum += b[i];
        }
        //doliczamy do sumy pojedyncze elementy dopoki jestesmy w tym samym bloku co r
        for(int i = br * s + 1; i <= r; i++){
            sum += x[i];
        }
    }
    return sum;
}

void value_change(int k, int u, vector<int>& x, int s, vector<long long>& b){
    b[(k - 1) / s] += u - x[k];
    x[k] = u;
}

int main(){
    int n, q;
    cin>>n>>q;
    vector<int> x(n+1, 0);
    // blocks size
    int s = (int) sqrt(n) + 1;
    // blocks sums
    vector<long long> b(s, 0);

    //wczytanie ciagu i obliczanie sum blokow
    for(int i=1; i<=n; i++){
        cin>>x[i];
        b[(i-1)/s] += x[i];
    }

    //obsluga zapytan
    for(int i=0; i<q; i++){
        int f;
        cin>>f;

        if(f == 1){
            int k, u;
            cin>>k>>u;
            value_change(k, u, x, s, b);
        }

        if(f == 2){
            int l, r;
            cin>>l>>r;
            cout<<count_sum(l, r, x, s, b)<<"\n";
        }
    }
    return 0;
}
