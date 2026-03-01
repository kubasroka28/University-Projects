#include <stdio.h>

//program wypisuje dni w kalendarzu dla podanego roku, miesiaca i dnia tygodnia, od ktorego się on zaczyna

int main()
{
	int ROK=0, MIES=0, DZIEN=0;
	printf(u8"Podaj po kolei liczby reprezentujce rok, miesiac i dzien tygodnia, od ktorego ten miesiac sie zaczyna(1-poniedzialek, 7-niedziela)\n");
	scanf("%d%d%d", &ROK, &MIES, &DZIEN);
	printf("\n");
	if((MIES>12)&&(DZIEN>7)) {printf("Wpisales niepoprawny numer miesiaca(>12) i niepoprawny numer dnia(>7)\n"); return 0;}
	if(MIES>12) {printf("Wpisales niepoprawny numer miesiaca(>12)\n"); return 0;}
    if(DZIEN>7) {printf("Wpisales niepoprawny numer dnia(>7)\n"); return 0;}

	int KAL[7][6];
	int LiczbaDniWMiesiacu=0;
	int TYG=1;


	if (MIES<8)
	{
		if (MIES%2==0) LiczbaDniWMiesiacu=30;
		else LiczbaDniWMiesiacu=31;
		if (MIES==2)
		{
			if (ROK%4==0)
			{
				LiczbaDniWMiesiacu=29;
				if (ROK%100==0) LiczbaDniWMiesiacu=28;
				if (ROK%400==0) LiczbaDniWMiesiacu=29;
			}
			else LiczbaDniWMiesiacu=28;
		}
	}
	if (MIES>=8)
	{
		if (MIES%2==0) LiczbaDniWMiesiacu=31;
		else LiczbaDniWMiesiacu=30;
	}


	for(int i=0; i<6; i++) //petla wypelnia cala tablice zerami
	{
		for(int j=0; j<7; j++)
		{
			KAL[j][i]=0;
		}
	}

	for(int i=1; i<=LiczbaDniWMiesiacu; i++) //petla wypelnia tablice numerami dni
	{
		KAL[DZIEN-1][TYG-1]=i;
		DZIEN++;
		if (DZIEN==8) {DZIEN=1; TYG++;} //printf("\n");}
	}

	for(int i=0; i<6; i++) //petla wypisuje tablice, tam gdzie nie ma numeru dnia daje spacje
	{
		for(int j=0; j<7; j++)
		{
			if(KAL[j][i]==0) printf("   ");
			else printf("%2d ", KAL[j][i]);
		}
		printf("\n");
	}

	return 0;
}
