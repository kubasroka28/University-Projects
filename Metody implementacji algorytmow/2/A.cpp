#include <iostream>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(0); 
    cin.tie(0);
    cout.tie(0);
        
    int t;
    cin>>t;
    for(int k = 0; k < t; k++){
        int n;
        cin>>n;
        long long beauty = 0;
        int second_minimums_minimum = 1e9 + 1;
        int minimums_minimum = 1e9 + 1;

        for(int i = 0; i < n; i++){
            int m;
            cin>>m;
            int array_minimum = 1e9 + 1;
            int array_second_minimum = 1e9 + 1;
            for(int j = 0; j < m; j++){
                int a;
                cin>>a;
                if(a < array_second_minimum){
                    if(a < array_minimum){
                        array_second_minimum = array_minimum;
                        array_minimum = a;
                    }
                    else array_second_minimum = a;                  
                }
            }

            beauty += array_second_minimum;

            minimums_minimum = min(minimums_minimum, array_minimum);
            second_minimums_minimum = min(second_minimums_minimum, array_second_minimum);
        }
 
        beauty = beauty - second_minimums_minimum + minimums_minimum;
        cout<<beauty<<endl;
    }
    return 0;
}




// #include <iostream>
// using namespace std;

// int main(){
//     int t;
//     cin>>t;
//     for(int k = 0; k < t; k++){
//         int n;
//         cin>>n;
//         long long beauty = 0;
//         int second_minimums_minimum = 1e9 + 1;
//         int minimums_minimum = 1e9 + 1;

//         for(int i = 0; i < n; i++){
//             int m;
//             cin>>m;
//             int array_minimum;
//             int array_second_minimum;

//             cin>>array_minimum;
//             cin>>array_second_minimum;
//             if(array_second_minimum < array_minimum) swap(array_minimum, array_second_minimum);
//             for(int j = 2; j < m; j++){
//                 int a;
//                 cin>>a;
//                 if(a < array_second_minimum){
//                     if(a < array_minimum){
//                         array_second_minimum = array_minimum;
//                         array_minimum = a;
//                     }
//                     else array_second_minimum = a;
//                 }
//             }

//             minimums_minimum = min(minimums_minimum, array_minimum);
//             second_minimums_minimum = min(second_minimums_minimum, array_second_minimum);
//             beauty += array_second_minimum;
//         }

//         beauty = beauty - second_minimums_minimum + minimums_minimum;
//         cout<<beauty<<endl;
//     }
// }
