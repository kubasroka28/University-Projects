#include <iostream>
#include <cmath>
#include <iomanip>
#define ld long double
#define ll long long
using namespace std;

ld distance(int xp1, int yp1, int xp2, int yp2, int xq, int yq){
    ll A = yp1 - yp2;
    ll B = xp2 - xp1;
    ll C = (ll)xp1 * yp2 - (ll)yp1 * xp2;

    ld numerator = abs((ld)(A * xq + B * yq + C));
    ld denominator = sqrt((ld)(A * A + B * B));

    return numerator / denominator;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);
    cout<<fixed<<setprecision(10);

    int q;
    cin>>q;
    for(int i = 0; i < q; i++){
        int xp1,yp1,xp2,yp2,xq,yq;
        cin>>xp1>>yp1>>xp2>>yp2>>xq>>yq;
        cout<<distance(xp1,yp1,xp2,yp2,xq,yq)<<"\n";
    }

    return 0;
}

/*
3
5 0 7 0 3 4
1 1 5 3 3 2
0 0 20 20 20 0


1
5 0 7 0 3 4

1
1000000000 1000000000 -1000000000 -1000000000 1000000000 -1000000000

1
1000000000 1000000000 1000000000 -1000000000 -1000000000 0
*/

