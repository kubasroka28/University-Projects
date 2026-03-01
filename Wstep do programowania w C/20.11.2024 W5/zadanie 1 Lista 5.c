#include <stdio.h>
#include <stdlib.h>
#include <string.h>


//Pytanie, czy jest cos zlego w ciaglym odwolywaniu sie do zmiennej, czy nalezy stworzyc zmienne lokalne
void MaxMinAvg(int n, double T[n], double* max, double* min, double* avg)
{
	//printf("max to %#lx, min to %#lx, a avg to %#lx\n",max,min,avg);
	double maxloc=T[0], minloc=T[0], avgloc=0;

	for(int i=0; i<n; i++)
	{
		if(T[i]>maxloc) maxloc=T[i];
		if(T[i]<minloc) minloc=T[i];
		avgloc+=T[i];
	}
	avgloc/=n;
	*max=maxloc; *min=minloc; *avg=avgloc;
	//printf("max to %f, min to %f, a avg to %f\n",max,min,avg);
}

char* NajwczesniejszeWystapienie(char* T, char c)
{
	int i=0;
	while(T[i])
	{
		if(T[i]==c) return &T[i];
		i++;
	}
	return NULL;
}

char* NajpozniejszeWystapienie(char* T, char c)
{
	int i=0;
	char* wynik=NULL;
	while(T[i])
	{
		if(T[i]==c) wynik=&T[i];
		i++;
	}
	return wynik;
}

void DoWielkich(char* T)
{
    int i=0;
    while(T[i])
    {
        if('a'<=T[i] && T[i]<='z') T[i]+=('A'-'a');
        i++;
    }
}

void DoMalych(char* T)
{
    int i=0;
    while(T[i])
    {
        if('A'<=T[i] && T[i]<='Z') T[i]+=('a'-'A');
        i++;
    }
}

void TitleCase(char* T)
{
    DoMalych(T);
    if('a'<=T[0] && T[0]<='z') T[0]+=('A'-'a');//sprawdzam czy pierwszy znak jest litera
    int i=1;
    while(T[i])
    {
        if(T[i-1]==' ' || T[i-1]=='\n' || T[i-1]=='\t' || T[i-1]=='\r' || T[i-1]=='\v' || T[i-1]=='\f')
        {
            if('a'<=T[i] && T[i]<='z') T[i]+=('A'-'a');
            //T[i]+=('A'-'a');
        }
        i++;
    }
}

void Odwracanie(char* T)
{
    int pom=0;
    int n=strlen(T);
    int i=0;
    while(i<(n/2))
    {
        pom=T[i];
        T[i]=T[n-i-1];
        T[n-i-1]=pom;
        i++;
    }
}

int main()
{
	//funkcja MaxMinAvg
	int n=5;
	double Liczby[5]={1,2,3,4,5};
	double max=0, min=0, avg=0;
	MaxMinAvg(n, Liczby, &max, &min, &avg);
	printf("max to %f, min to %f, a avg to %f\n",max,min,avg);


	//funkcje NajwczesniejszeWystapienie i NajpozniejszeWystapienie
	char Napis[]={"abcdedcba"};
	char Znak='c';
	//printf("adres komorki napisu, w ktorej najwczesniej wystepuje litera '%c' to:%p\n",Znak, NajwczesniejszeWystapienie(Napis, Znak));
	//mozna zobaczyc, ze funkcje dzialaja poprawnie wypisujac napis od pozycji, na ktore pokazuja wskazniki zwrocone przez funkcje
	printf("Napis od pierwszego wystapienia znaku %c to:%s\n",Znak, NajwczesniejszeWystapienie(Napis, Znak));
    printf("Napis od ostatniego wystapienia znaku %c to:%s\n",Znak, NajpozniejszeWystapienie(Napis, Znak));

    //funkcje DoWielkich, DoMalych
    char Napis1[]="testOWANIE";
    char Napis2[]="TESTowanie";
    char Napis3[]="male WIELKIE rOzNe dziwne slowa i &z,n.a>k!i.";
    char Napis4[]="Napis od tylu, kajak";

    DoWielkich(Napis1);
    printf("Napis po wywolaniu funkcji DoWielkich wyglada tak: %s\n",Napis1);
    DoMalych(Napis2);
    printf("Napis po wywolaniu funkcji DoMalych wyglada tak: %s\n",Napis2);
    TitleCase(Napis3);
    printf("Napis po wywolaniu funkcji TitleCase wyglada tak: %s\n",Napis3);
    Odwracanie(Napis4);
    printf("Napis po wywolaniu funkcji Odwracanie wyglada tak: %s\n",Napis4);

	return 0;
}
