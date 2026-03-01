#include <stdio.h>

/* sprawdzanie obecnosci licz bezkwadratowych */

int main(void)

{

int A=0;
int x;
//x to kolejne kwadraty liczb naturalnych

int pom;
//zmienna mówi, przez której liczby kwadrat teraz dzielę

int warunek;
//ta zmienna mówi, czy liczna jest bezkwadratowa czy nie

scanf("%d", &A);

for(int i=0; i<=1000; i++)
{
    x=4;
    pom=2;
    warunek=1;
    while(x<=A)
    {
        if(A%x==0) //czy x dzieli A?
        {
            warunek=0; //jeżeli tak to warunek jest nie spełniony
        }
        pom++;
        x=pom*pom;

        if (warunek==0) x=A+1; //jeżeli warunek jest nie spełniony to wychodzę z petli, która go sprawdza
    }
    if(warunek==1)
    {
        printf("%d ", A); //jeżeli po wyjściu z pętli warunek wciąż jest prawdziwy to znaczy, że liczba A jest liczbą bezkwadratową i można ją wypisać
        i=1001; //jeżeli wypisałem już najmniejszą liczbę bezkwadratową z przedziału to mogę przerwać pętlę
    }
    A++;
}

if(warunek==0) printf("BRAK");

return 0;
}
