#include <iostream>
#include <vector>
using namespace std;

const int TOP_x = 1000000;

void sieve(vector<int>& lowest_divisor){
    lowest_divisor[1] = 1;
    for (int k = 2; k <= TOP_x; k += (k == 2 ? 1 : 2)){
         if(lowest_divisor[k] == 0){
            for (int i = k; i <= TOP_x; i += k) {
                if (lowest_divisor[i] == 0)
                    lowest_divisor[i] = k;
            }
        }
    }
}

int eulers_totient_function(int x, vector<int>& lowest_divisor){
    int result = x;
    while(x != 1){
        int temp = lowest_divisor[x];
        while (lowest_divisor[x] == temp) x /= temp;
        result -= result / temp;
    }
    return result;
}

int main(){
    int n;
    cin>>n;
    vector<int> lowest_divisor(TOP_x+1, 0);
    sieve(lowest_divisor);
    for(int i=0; i<n; i++){
        int x;
        cin>>x;
        cout<<eulers_totient_function(x, lowest_divisor)<<"\n";
    }
    return 0;
}
