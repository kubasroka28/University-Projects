#include <iostream>

using namespace std;

unsigned long long int NWD(unsigned long long int a,unsigned long long int b){
    unsigned long long int c = 0;
    while(b != 0){
        c = b;
        b = a % b;
        a = c;
    }
    return a;
}

int main(){
unsigned long long int a, b;
cin>>a>>b;
cout<<NWD(a,b);

return 0;
}
