#include "number_utils.h"

//Funkcja oblicza ile jest cyfr w liczbie
int count_digits(int number)
{
    int counter=0;

    while(number>0)
    {
        counter++;
        number/=10;
    }

    return counter;
}

//Funkcja zamienia kolejnosc cyfr w liczbie na odwrocona
int reverse_number(int number)
{
    int reversed_number=0;

    while(number>0)
    {
        reversed_number=10*reversed_number+(number%10);
        number/=10;
    }

    return reversed_number;
}

//Funkcja oblicza sume cyfr liczby
int digit_sum(int number)
{
    int sum_counter=0;

    while(number>0)
    {
        sum_counter+=(number%10);
        number/=10;
    }

    return sum_counter;
}
