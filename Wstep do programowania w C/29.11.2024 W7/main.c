#include <stdio.h>
#include "math_ops.h"
#include "number_utils.h"

int main()
{
	//Obliczanie silni
	int n=8;
	printf("%d silnia to %d\n",n,factorial(n));

	//Obliczanie potegi
	double base=0.5;
	int exponent=3;
	printf("%f do potegi %d to %f\n",base,exponent,power(base,exponent));

	//Sprawdzanie czy liczba jest pierwsza
	int m=37;
	printf("Liczba %d ",m);
	is_prime(m) ? :printf("nie ");
	printf("jest pierwsza\n");

	//sprawdzanie ile jest cyfr w liczbie
	int l=1234567;
	printf("Liczba %d ma %d cyfr\n",l,count_digits(l));

	//odwracanie kolejnosci cyrf w liczbie
	int k=112233;
	printf("Odwrocona liczba %d to %d\n",k,reverse_number(k));

	//obliczanie sumy cyfr liczby
	int i=123123;
	printf("Suma cyfr liczby %d to %d\n",i,digit_sum(i));

	return 0;
}
