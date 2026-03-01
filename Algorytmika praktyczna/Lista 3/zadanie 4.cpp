

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

void merge_sort(int l, int r, int coordinate, int up_or_down_for_y, vector<int>& x, vector<int>& y, vector<int>& inversed_permutation) {
    if (l >= r) return;

    int s = (l + r) / 2;
    merge_sort(l, s, coordinate, up_or_down_for_y, x, y, inversed_permutation);
    merge_sort(s + 1, r, coordinate, up_or_down_for_y, x, y, inversed_permutation);

    int left_size = s - l + 1;
    int right_size = r - s;
    vector<int> x_left_side(left_size), x_right_side(right_size);
    vector<int> y_left_side(left_size), y_right_side(right_size);
    vector<int> permutation_left_side(left_size), permutation_right_side(right_size);

    for (int j = 0; j < left_size; j++) {
        x_left_side[j] = x[l + j];
        y_left_side[j] = y[l + j];
        permutation_left_side[j] = inversed_permutation[l + j];
    }
    for (int k = 0; k < right_size; k++) {
        x_right_side[k] = x[s + 1 + k];
        y_right_side[k] = y[s + 1 + k];
        permutation_right_side[k] = inversed_permutation[s + 1 + k];
    }

    int j = 0, k = 0;
    if(coordinate == 0){ // sorting by x
        for (int i = l; i <= r; i++) {
            if (j < left_size && (k >= right_size || x_left_side[j] < x_right_side[k])) {
                x[i] = x_left_side[j];
                y[i] = y_left_side[j];
                inversed_permutation[i] = permutation_left_side[j];
                j++;
            } else {
                x[i] = x_right_side[k];
                y[i] = y_right_side[k];
                inversed_permutation[i] = permutation_right_side[k];
                k++;
            }
        }
    }
    else{ // sorting by y
        if(up_or_down_for_y == 1){ // sorting up
            for (int i = l; i <= r; i++) {
                if (j < left_size && (k >= right_size || y_left_side[j] < y_right_side[k])) {
                    x[i] = x_left_side[j];
                    y[i] = y_left_side[j];
                    inversed_permutation[i] = permutation_left_side[j];
                    j++;
                } else {
                    x[i] = x_right_side[k];
                    y[i] = y_right_side[k];
                    inversed_permutation[i] = permutation_right_side[k];
                    k++;
                }
            }
        }
        else{ // sorting down
            for (int i = l; i <= r; i++) {
                if (j < left_size && (k >= right_size || y_left_side[j] > y_right_side[k])) {
                    x[i] = x_left_side[j];
                    y[i] = y_left_side[j];
                    inversed_permutation[i] = permutation_left_side[j];
                    j++;
                } else {
                    x[i] = x_right_side[k];
                    y[i] = y_right_side[k];
                    inversed_permutation[i] = permutation_right_side[k];
                    k++;
                }
            }
        }
    }
}

int main(){
    int n, q;
    cin>>n>>q;
    vector<int> x(n+1);
    for(int i=0; i<n; i++){
        cin>>x[i];
        if(x[i] > n) x[i] = n + 1;
    }
    int block_width = (int) sqrt(n) + 1;
    vector<int> p(q);
    vector<int> k(q);
    vector<int> inversed_permutation(q);
    for(int i=0; i<q; i++){
        cin>>p[i]>>k[i];
        p[i]--;
        k[i]--;
        inversed_permutation[i] = i;
    }

    //sortowanie punktow
    merge_sort(0, q-1, 0, 0, p, k, inversed_permutation);
    int left_points_bound = 0, right_points_bound = 0;
    for(int i=1; i<=block_width; i++){
        while(right_points_bound < q - 1 && p[right_points_bound] < i * block_width) right_points_bound++;
        merge_sort(left_points_bound, right_points_bound, 1, i%2 ? 1 : 0, p, k, inversed_permutation);
        left_points_bound = right_points_bound + 1;
    }

    vector<int> permutation(q);
    for(int i=0; i<q; i++){
        permutation[inversed_permutation[i]] = i;
    }

    //liczenie wynikow dla poszczegolnych przedzilow
    vector<int> wystapienia(n+2, 0);
    vector<int> wynik(q);
    wynik[0] = 0;

    for(int i = p[0]; i <= k[0]; i++){
        wystapienia[x[i]]++;
        if(wystapienia[x[i]] == x[i]) wynik[0]++;
        else if(wystapienia[x[i]] - 1 == x[i]) wynik[0]--;
    }

    for(int i = 1; i <q ; i++){
        wynik[i] = wynik[i - 1];
        for(int j = p[i-1]; j < p[i]; j++){
            wystapienia[x[j]]--;
            if(wystapienia[x[j]] == x[j]) wynik[i]++;
            else if(wystapienia[x[j]] + 1 == x[j]) wynik[i]--;
        }
        for(int j = p[i-1] - 1; j >= p[i]; j--){
            wystapienia[x[j]]++;
            if(wystapienia[x[j]] == x[j]) wynik[i]++;
            else if(wystapienia[x[j]] - 1 == x[j]) wynik[i]--;
        }
        for(int j = k[i-1]; j > k[i]; j--){
            wystapienia[x[j]]--;
            if(wystapienia[x[j]] == x[j]) wynik[i]++;
            else if(wystapienia[x[j]] + 1 == x[j]) wynik[i]--;
        }
        for(int j = k[i-1] + 1; j <= k[i]; j++){
            wystapienia[x[j]]++;
            if(wystapienia[x[j]] == x[j]) wynik[i]++;
            else if(wystapienia[x[j]] - 1 == x[j]) wynik[i]--;
        }
    }

    for(int i=0; i<q; i++){
        cout<<wynik[permutation[i]]<<"\n";
    }

    return 0;
}

