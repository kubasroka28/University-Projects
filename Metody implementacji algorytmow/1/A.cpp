#include <iostream>
 
using namespace std;
 
int main(){
    int n;
    cin>>n;
    int a = 0; //anwser
    int B[5] = {1,5,10,20,100}; //bills table
    int i = 4; //iterator
    while(n > 0){
        if(n >= B[i]){
            a++;
            n -= B[i];
        }
        else i--;
    }
    cout<<a; 
}