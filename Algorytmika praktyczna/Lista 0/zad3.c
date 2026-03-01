#include <stdio.h>

int SzybPot(int A, int N){
    if(N == 0) return 1;
    else if(N % 2 == 0) return SzybPot(A, (N-1)/2) * SzybPot(A, (N-1)/2);
    return SzybPot(A, N/2) * SzybPot(A, N/2) * A;
}

int main(){
    int A=0, N=0;
    scanf("%d %d", &A, &N);
    printf("%d",SzybPot(A,N));
    return 0;
}
