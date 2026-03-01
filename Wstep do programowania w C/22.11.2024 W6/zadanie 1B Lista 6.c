#include <stdio.h>

int main()
{
	int wzorzec=0;
	printf("Podaj wzorzec o dlugosci<=60\n");
	scanf("%d",&wzorzec);
	//printf("wzorzec:%d\n",wzorzec); //czy jak wzorzec ma 0 na poczatku to to jest zapisane w int? //teraz to juz sam nie wiem, ale tez nie wiem czy to ma znaczenie
	//if(0010U & wzorzec) printf("tak\n");
	int napis=7;
	/*for(int i=0; i<1; i++) //while(getchar()!=EOF) cos takiego chyba trzeba zrobic
	{
		napis=getchar();
		//getchar(napis);
	}*/
	/*do
    {
        putchar(napis);
    } while( ( napis = getchar() ) != '\n');


    do
    {
        napis+=getchar()-'0';
        printf("%d ",napis);
        //putchar(napis);
    }while(napis!='\n');*/

    /*char znak=0;
    int liczba=0;
    do
    {
        znak=getchar();
        liczba=znak-'0';
        printf("%d ",liczba);
    }while(znak!='\n');*/

    /*int znak;
    //=getchar();
    scanf("%c",&znak);
    printf("%d",znak);
    //putchar(znak);
    while((znak=getchar()) != '\n')
    {
        putchar(znak);
    }*/


    //nie wiem co zrobic, zeby to dzialalo
    int okienko=0;
    for(int i=1; i<=wzorzec; i*=10)//wczytywanie pierwszego okienka
    {
        char c=getchar();
        while (c == '\n') c = getchar();
        //scanf("%c",&c);
        //putchar(c);
        okienko=okienko*10+(c-'0');
        //okienko+=i*(getchar()-'0');
        //putchar('x');
    }
    //printf("%d\n",okienko);

    //if(wzorzec & okienko) putchar('0');
    printf("koniunkcja:%d",(wzorzec & okienko));

    okienko<<=1;
    //printf("%d\n",okienko);

	//printf("%d\n",napis);
	return 0;
}
