// Jakub Sroka 22.03.2025

#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

#define field_size 1000000

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
    int n;
    cin>>n;
    int field_width = (int) sqrt(field_size) + 1;
    vector<int> x(n);
    vector<int> y(n);
    vector<int> inversed_permutation(n);
    for(int i=0; i<n; i++){
        cin>>x[i]>>y[i];
        inversed_permutation[i] = i;
    }

    //sortowanie punktow
    merge_sort(0, n-1, 0, 0, x, y, inversed_permutation);
    int left_points_bound = 0, right_points_bound = 0;
    for(int i=1; i<=field_width; i++){
        while(right_points_bound < n - 1 && x[right_points_bound] < i * field_width) right_points_bound++;
        merge_sort(left_points_bound, right_points_bound, 1, i%2 ? 1 : 0, x, y, inversed_permutation);
        left_points_bound = right_points_bound + 1;
    }

//    cout<<"\n";
//    for(int i=0; i<n; i++){
//        cout<<x[i]<<" "<<y[i]<<"\n";
//    }
//    cout<<"\n";
    for(int i=0; i<n; i++){
        cout<<(inversed_permutation[i] + 1)<<" ";
    }

    return 0;
}
