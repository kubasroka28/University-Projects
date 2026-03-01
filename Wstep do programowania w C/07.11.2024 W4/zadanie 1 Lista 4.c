#include <stdio.h>
#include <stdlib.h>

//Jakub Sroka 355255 Lista 4 zadanie 1

double funkcja(int n, int k, double a[], double f[])
{
    for(int i=k; i<=n; i++)//trzeba policzyc po kolei f(k),f(k+1),... i w koncu f(n)
    {
        f[i]=0;//inicjuje zmienna, bo potem stosuje +=
        for(int j=0; j<k; j++)//konkretny element ciagu to suma k poprzednich z odpowiednimi wspolczynnikami a0,a1,...a(k-1)
        {
            f[i]+=a[j]*f[i-j-1];
        }
    }
    return f[n];
}

int main(int argc, char *argv[])
{
	int k=atoi(argv[1]);
	if(k<=0) {printf("k podane w parametrach wywolania programu jest bledne"); return 0;}
	if(argc<2*k+2) {printf("podales zla liczbe argumentow wejsciowych"); return 0;}

	int n=0;
	printf("Podaj n (n>=%d):",k);
	scanf("%d",&n);
	if(n<k) {printf("Podales zle n"); return 0;}

	double a[k];
	double f[n+1];
	for(int i=0; i<k; i++)
	{
		a[i]=atof(argv[i+2]);
	}
	for(int i=0; i<k; i++)
	{
		f[i]=atof(argv[i+k+2]);
	}

    printf("f(n)=%f",funkcja(n,k,a,f));

	return 0;
}
