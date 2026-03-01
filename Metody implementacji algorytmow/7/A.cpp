//A. Sushi for Two
#include <bits/stdc++.h>
using namespace std;
 
int main(){
    int n;
    cin>>n;
    vector<int> segments; //lenghts of segments of sushi types
    int pt; //previous type
    for(int i = 0; i < n; i++){
        int t;
        cin>>t;
        if(i == 0) segments.push_back(1);
        else{
            if(t == pt) segments.back()++;
            else segments.push_back(1);                
        }
        pt = t;
    }
    int psl = 0; //previous segment length
    int anwser = 0;//maximum length of a valid continuous segment
    for(auto elem : segments){
        anwser = max(anwser, min(psl, elem));
        psl = elem;
    }
    cout<<anwser * 2;
}