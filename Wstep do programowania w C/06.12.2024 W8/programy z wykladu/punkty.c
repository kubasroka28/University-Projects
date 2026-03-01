#include <math.h>
#include "punkty.h"

/* Moduł PUNKTY implementujący operacje na punktach i wektorach 2-wymiarowych. */

struct wektor punkty_na_wektor(struct punkt p0,struct punkt p1)
{
    struct wektor w;

    w.x=p1.x-p0.x;
    w.y=p1.y-p0.y;
    return w;
}

void dodaj_wektor(struct punkt *p,struct wektor w)
{
    p->x+=w.x;
    p->y+=w.y;
}

struct wektor prostopadly(struct wektor w)
{
    struct wektor wp = { .x = -w.y, .y = w.x };

    return wp;
}

struct wektor mnoz_przez_liczbe(struct wektor w,float a)
{
    w.x*=a;
    w.y*=a;
    return w;
}

struct punkt trojkat_rb(struct punkt p1,struct punkt p2)
{
    struct wektor w12,w14,w43;
    struct punkt p3 = p1;
    
    w12=punkty_na_wektor(p1,p2);
    w14=mnoz_przez_liczbe(w12,0.5);
    w43=mnoz_przez_liczbe(prostopadly(w14),sqrt(3.0));
    dodaj_wektor(&p3,w14);
    dodaj_wektor(&p3,w43);
    return p3;
} 

double dlugosc(struct wektor w)
{
    return sqrt(w.x*w.x+w.y*w.y);
}