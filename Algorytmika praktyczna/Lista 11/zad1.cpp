#include <iostream>
#define ll long long
using namespace std;

string positioning(int x1, int y1, int x2, int y2, int x3, int y3){
    ll vector_product = (ll)(x2 - x1) * (ll)(y3 - y1) - (ll)(x3 - x1) * (ll)(y2 - y1);
    if(vector_product == 0) return "TOUCH";
    else if (vector_product > 0) return "LEFT";
    else return "RIGHT";
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int T;
    cin>>T;
    for(int i = 0; i < T; i++){
        int x1,y1,x2,y2,x3,y3;
        cin>>x1>>y1>>x2>>y2>>x3>>y3;
        cout<<positioning(x1,y1,x2,y2,x3,y3)<<"\n";
    }
    return 0;
}


