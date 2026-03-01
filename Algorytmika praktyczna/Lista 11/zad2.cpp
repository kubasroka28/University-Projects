#include <iostream>
#include <iomanip>
#define ll long long
using namespace std;

ll cross_product(int x1, int y1, int x2, int y2){
    return (ll)x1 * (ll)y2 - (ll)x2 * (ll)y1;
}

ll doubled_polygon_area(int n, int vertices[][2]){
    ll area = 0;
    for(int i = 0; i < n; i++){
        area += cross_product(vertices[i][0], vertices[i][1], vertices[(i + 1) % n][0], vertices[(i + 1) % n][1]);
    }
    area = abs(area);
    return area;
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int n;
    cin>>n;
    int vertices[n][2];
    for(int i = 0; i < n; i++){
        int x,y;
        cin>>x>>y;
        vertices[i][0] = x;
        vertices[i][1] = y;
    }

    ll result = doubled_polygon_area(n, vertices);
    cout<<result/2;
    if(result % 2 == 0) cout<<".0";
    else cout<<".5";

    return 0;
}



