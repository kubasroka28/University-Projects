/************* OPERACJE NA PUNKTACH I WEKTORACH **************/

struct punkt {
    float x;
    float y;
} ;

struct wektor {
    float x;
    float y;
} ;

/******************** PROTOTYPY FUNKCJI *********************/

struct wektor punkty_na_wektor(struct punkt p0,struct punkt p1);
void          dodaj_wektor(struct punkt *p,struct wektor w);
struct wektor prostopadly(struct wektor w);
struct wektor mnoz_przez_liczbe(struct wektor w,float a);
struct punkt  trojkat_rb(struct punkt p1,struct punkt p2);
double        dlugosc(struct wektor w);

