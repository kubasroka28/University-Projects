// Jakub Sroka 01.04.2025
// Zlozonosc O( n^2 * 2^n )

#include <iostream>
#include <vector>
using namespace std;

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n;
    cin>>n;
    // first cord are people, second cord are stations
    vector<vector<int>> profits(n, vector<int>(n));
    for(int l = 0; l < n; l++){
        for(int m = 0; m < n; m++){
            cin>>profits[l][m];
        }
    }
    int scope = (1 << n);
    vector<int> DP(scope, 0);

//    for(int worker = 0; worker < n; worker++){
//        for(int mask = 0; mask < scope; mask++){
//            if(__builtin_popcount(mask) != worker) continue;
//            for(int free_station = 0; free_station < n; free_station++){
//                int free_station_byte = 1 << (n - 1 - free_station);
//                if((free_station_byte & mask) != 0) continue;
//                DP[mask | free_station_byte] = max(DP[mask | free_station_byte], DP[mask] + profits[worker][free_station]);
//            }
//        }
//    }


// z jakiegoś powodu to nie działa
    for(int mask = 0; mask < scope; mask++){
        for(int free_station = 0; free_station < n; free_station++){
            int free_station_byte = 1 << (n - 1 - free_station);
            if((free_station_byte & mask) != 0) continue;

            DP[mask | free_station_byte] = max(DP[mask | free_station_byte], DP[mask] + profits[__builtin_popcount(mask)][free_station]);
        }
    }

    cout<<DP[scope-1];

    return 0;
}

