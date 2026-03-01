#include <iostream>
#include <vector>
using namespace std;
 
int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);
    
    int t;
    cin>>t;
    for(int s = 0; s < t; s++){
        int n;
        cin>>n;
        /*
        Dla każdej liczby k chcę wiedzieć ile razy ona wystąpiła na indeksach,
        które już przeszedłem. Będę to miał w tablicy A
        
        Dla każdej liczby k chcę mieć tablicę I_k , do której kładę kolejne indeksy,
        na których występuje liczba k.
        
        Kiedy przechodzę przez napis, jestem na indeksie i, a na nim jest liczba k to
        muszę to odnotować. Najpierw zapiszę nowy indeks, wystąpienia liczby k.
        Będzie to oczywiście i, natomiast indeksem w tablicy I_k gdzie muszę to wpisać
        jest A[k] (Jeżeli jest A[k] wystąpień k to są one odnotowane
        w I_k na indeksach 0,1,2,...,A[k]-1, czyli następny to właśnie A[k]).
        Zatem I_k[A[k]] = i. Pozostaje zwiększyć liczbę wystąpięń liczby k,
        czyli A[k]+=1.
 
        Teraz mogę sprawdzić jaka będzie wartość L[i]. Jeżeli wystąpień liczby k jest mniej
        niż k to nie mogę stworzyć bloku, więc po prostu L[i]=L[i-1]. Jeśli jest ich wystarczająco to jest nowy kandydat.
        Muszę znaleźć najdalszy możliwy początek bloku z liczby k. Jest on w tablicy I_k pod indeksem A[k]-k.
        Jeżeli I_k[A[k]-k] == 0 to porównuję po prostu L[i]=max(L[i-1], k).
        Jeżeli I_k[A[k]-k] != 0 to L[i]=max(L[i-1], L[I_k[A[k]-k] - 1] + k).
 
        Po wyznaczeniu L[i] przechodzę na następną pozycję.
        */
        vector<int> L(n+1); //Longest neat subsequence ending before or at a_i
        vector<int> A(n+1); //Amount of occurences of i
        vector<vector<int>> I(n+1); //Indexes of occurences of i
        
        int k;
        cin>>k;
        //I[k][A[k]] = 1;
        I[k].push_back(1);
        A[k]++;        
        if(k == 1) L[1] = 1;
        else L[1] = 0;
        for(int i = 2; i <= n; i++){
            cin>>k;
            //I[k][A[k]] = i;
            I[k].push_back(i);
            A[k]++;
            if(A[k] < k){
                L[i] = L[i-1];
            }
            else if(I[k][A[k]-k] == 0){
                L[i] = max(L[i-1], k);
            }
            else L[i] = max(L[i-1], L[I[k][A[k]-k] - 1] + k);
        }
        cout<<L[n]<<"\n";   
    }
}