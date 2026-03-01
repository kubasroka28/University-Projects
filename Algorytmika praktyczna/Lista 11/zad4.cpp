#include <iostream>
#include <vector>
#include <algorithm>
#define ll long long
using namespace std;

typedef struct point{
    ll x;
    ll y;
}point;

ll product(ll x1, ll y1, ll x2, ll y2){
    return x1 * y2 - y1 * x2;
}

bool comp(point a, point b){
    return (product(a.x, a.y, b.x, b.y) > 0);
}

int main(){
    cin.tie(0);
    cout.tie(0);
    ios_base::sync_with_stdio(0);

    int xq, n;
    cin>>xq>>n;
    vector<point> points(n);
    for(int i = 0; i < n; i++){
        cin>>points[i].x>>points[i].y;
        points[i].x -= xq;
    }
    sort(points.begin(), points.end(), comp);
    int result = n;
    for(int i = 0; i < n - 1; i++){
        if(product(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y) == 0) result--;
    }
    cout<<result;

    return 0;
}

/*
0 6
-2 1
-2 2
1 2
-1 2
2 2
2 1
*/



