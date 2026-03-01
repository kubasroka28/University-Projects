#include <bits/stdc++.h>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);

    int t;
    cin>>t;
    while(t--){
       int n;
       cin>>n;
       int a[n];
       for(int i = 0; i < n; i++){
            cin>>a[i];
       }
       map<int, int> M; //this map contains pairs of odd numbers and the biggest powers of 2 which appeared with them in the same prime factorization of some a[i]
       for(int i = 0; i < n; i++){
           int c = 0; //a counter of twos in the prime factorization of a[i]
           while(a[i] % 2 == 0){
               a[i] /= 2;
               c++;
           }
           auto key = M.find(a[i]);
           if(key != M.end()){ //I check wether this odd number was aquired before
                M[a[i]] = max(M[a[i]], c);//If yes I compare the old value with the new value and save the max
           }
           else M.insert({a[i], c});//If not I just save the calculated value
       }
       int anwser = 0;
       //for every achieved odd number I add the maximum amount of twos which appeared with this number in the prime factorization of some a[i]
       //That is equal to the emount of moves I would have to make to achieve this odd number
       for(auto x : M){
            anwser += x.second;
       }
       cout<<anwser<<"\n";
    }
    return 0;
}