#include <iostream>
using namespace std;
 
struct mypair{
    int n; //number
    int a; //amount
};

int main(){
    ios_base::sync_with_stdio(false);
    cin.tie(0);
    cout.tie(0);
    
    int t;
    cin>>t;
    /*for(int k = 0; k < t; k++){
        int n;
        cin>>n;
        mypair test[n];
        for(int i = 0; i < n; i++){
            test[i].n = 0;
            test[i].a = 0;
        }

        int a;
        cin>>a;
        int j = 0;
        test[j].n = a;
        test[j].a = 1;
        for(int i = 0; i < n - 1; i++){
            cin>>a;
            if(a == test[j].n){
                test[j].a++;
            }
            else{
                j++;
                test[j].n = a;
                test[j].a = 1;
            }
        }

        // for(int i = 0; i < n; i++){
        //     cout<<"("<<test[i].n<<","<<test[i].a<<")"<<endl;
        // }

        int anwser = 0;
        for(int i = 0; i < n; i++){
            if(test[i].n != 0)
                anwser += (test[i].a / test[i].n) * test[i].n;
        }
        // cout<<"anwser:"<<anwser<<endl;        
        cout<<anwser<<endl;
    }*/
    
    for(int k = 0; k < t; k++){
        int n;
        cin>>n;
        int L[n]; //tablica, która mówi jaki jest najdłuższy "neat" podciąg do indeksu i (Longest)
        int A[n]; //tablica, która mówi jaka jest ilość niewykorzystanych wystąpień liczby a_i (Amount)
        int F[n]; //tablica, która mówi na jakim indeksie stoi pierwsza niewykorzystana liczba a_i (First appearance)        
        for(int i = 0; i < n; i++){
            L[i] = 0;
            A[i] = 0;
            F[i] = 0;
        } 

        int a;
        cin>>a;
        if (a == 1){
            L[0] = 1;
        }
        else{
            A[a-1] = 1;
            F[a-1] = 0;
        }
        for(int i = 1; i < n; i++){
            cin>>a;
            if(A[a-1] = a - 1){
                if(F[a-1] == 0){
                    L[i] = a;
                    A[a-1] = 0;
                }
                else if(L[F[a-1]-1] + a > L[i - 1]){
                    L[i] = L[F[a-1]-1] + a;
                    A[a-1] = 0;
                }
                else{
                    L[i] = L[i-1];
                    //Tutaj jest problem, pojawiło się nowe 'a', ale nie opłaciło się go wykorzystać. Jednak gdybym w przyszłości wykorzystywał 'a' to początek jego bloku będzie inny niż
                    //F[a-1]. Potrzebuję w takim razie wektor, w którym będę trzymał indeks wszystkich kolejnych pozycji 'a'.
                }
            }
            else{
                if(A[a-1] == 0){
                    F[a-1] = i;
                }
                A[a-1]++;
                L[i] = L[i-1];
            }
        } 
        cout<<L[n-1]<<"\n";      
    }

    return 0;
}