#include "math_ops.h"

//Funkcja obliczba silnie z liczby n.
//Jezeli wyliczenie nastepnej wartosci silni przekroczy INT_MAKS to go nie wykonamy.
//To oznacza, ze dla liczby typu int obliczymy maksymalnie silnia 12,
//czyli dla n>12 bedziemy zawsze zwracac 12!
int factorial(int n)
{
	if(n<=0) return 0;
	int wynik=1;
	for(int i=1; i<=n; i++)
	{
		//jezeli kolejne obliczenie silni przekracza INT_MAKS to go nie wykonujemy
		if(MAKS_FACTORIAL/i>wynik) wynik*=i;
	}
	return wynik;
}

//Funkcja oblicza wartosc 'base' podniesionej do potegi o wykladniku rownym 'exponent'
double power(double base, int exponent)
{
	double wynik=1;
	for(int i=0; i<exponent; i++)
	{
		wynik*=base;
	}
	return wynik;
}

//Funkcja sprawdza czy liczba jest pierwsza, czy nie.
//Jezeli tak to zwraca wartosc 1, a wpp 0
int is_prime(int number)
{
	if(number<0) number*=(-1);
	if(number==1) return 0;
	int dzielnik=2;
	int prime_condition=1;
	while(dzielnik*dzielnik<number)
	{
		if(number%dzielnik==0) prime_condition=0;
		dzielnik+=1;
	}

	return prime_condition;
}
