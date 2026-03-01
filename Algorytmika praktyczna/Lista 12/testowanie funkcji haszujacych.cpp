#include <iostream>
#include <cmath>
#include <vector>

#define ll long long

using namespace std;

ll power(int base, int exponent){
    ll result = 1;
    while(exponent > 0){
        if(exponent % 2 == 1) result *= base;
        base *= base;
        exponent /= 2;
    }
    return result;
}

int char_to_int(char c){
    return (c - 'a' + 1);
}

int fun1(string s){
    int result = 0;
    for(int i = 0; i < s.length(); i++){
        result += char_to_int(s[i]);
    }
    return result;
}

int fun2(string s){
    ll result = 0;
    ll A = 32;
    ll M = (ll)1 << 31;
    for(int i = 0; i < s.length(); i++){
        result += (char_to_int(s[i]) * power(A,i)) % M;
    }
    return result;
}

ll fun3(string s){
    ll result = 0;
    ll A = 34;
    ll M = 1000000000;
    for(int i = 0; i < s.length(); i++){
        result += (char_to_int(s[i]) * power(A,i)) % M;
    }
    return result;
}

void tworz_slowo(int ile_jeszcze_pozycji, string curr_s){
    if(ile_jeszcze_pozycji == 0){
        cout<<curr_s<<"\n";
        cout<<fun1(curr_s)<<endl<<fun2(curr_s)<<endl<<fun3(curr_s)<<endl<<endl;
        return;
    }
    for(char c = 'a'; c <= 'z'; c++){
        tworz_slowo(ile_jeszcze_pozycji - 1, curr_s + c);
    }
    return;
}

int main(){
    for(int d = 1; d <= 1; d++){//dlugosc
        tworz_slowo(d, "");
    }


    return 0;
}
