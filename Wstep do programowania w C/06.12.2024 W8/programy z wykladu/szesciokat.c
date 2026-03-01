#include <stdio.h>
#include "punkty.h"

/**************** WYZNACZANIE WSPOLRZEDNYCH SZESCIOKATA FOREMNEGO **********/
/*
 *  Ten program należy kompilować łącznie z modułem punkty.c
 *    np. poleceniem: gcc -std=c99 -o szesciokat szesciokat.c punkty.c -lm
 *    lub tworząc odpowiedni projekt w Code::Blocks
 */   

int main(void)
{
    struct punkt p1,p2,ps,pp,pn;
    int i;
    

    printf("Podaj wspolrzedne dwoch wierzcholkow szesciokata foremnego\n");
    printf("x1  y1 = "); scanf("%f %f",&p1.x,&p1.y);
    printf("x2  y2 = "); scanf("%f %f",&p2.x,&p2.y);
    ps=trojkat_rb(p1,p2);
    for (i=3,pp=p2; i <= 6; ++i,pp=pn) {
        pn=trojkat_rb(ps,pp);
        printf("%i-%s    wierzcholek ma wspolrzedne (x%i,y%i) = (%.2f,%.2f)\n",
            i,(i==3 ? "ci" : "ty"),i,i,pn.x,pn.y);
    }
    return 0;
}
