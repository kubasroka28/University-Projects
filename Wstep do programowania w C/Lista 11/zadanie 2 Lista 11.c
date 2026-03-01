#include <stdio.h>

int main(){
	int n=0, m=0;
	scanf("%d%d", &n, &m);
	getchar();
	//printf("n: %d, m: %d\n", n, m);
	//wczytywanie wartosci poziomow energii
	int zarowki[n][n];
	for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			zarowki[i][j] = getchar() - '0';
			//scanf("%d", &zarowki[i][j]);
		}
		getchar();
	}
	//test wczytywania danych
	/*for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			printf("%d ", zarowki[i][j]);
		}
		putchar('\n');
	}	*/
	//inicjalizowanie tablicy czy_rozblysla
	int czy_rozblysla[n][n];
	for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			czy_rozblysla[i][j] = 0;
		}
	}

	//przechodzenie przez m krokow
	int ile_rozblyskow = 0;
	for(int i=0; i<m; i++){
		//sekwencja 1
		//ladowanie zarowek
		for(int i=0; i<n; i++){
			for(int j=0; j<n; j++){
				zarowki[i][j]+=1;
			}
		}

		//sekwencja 2
		//rozblyski zarowek

		//trzeba wracac i sprawdzac czy jeszcze cos blyska
		int cos_blyska = 1;
		while(cos_blyska){
			cos_blyska = 0;
			for(int i=0; i<n; i++){
				for(int j=0; j<n; j++){
					if(zarowki[i][j] >= 10 && czy_rozblysla[i][j] == 0){
						//printf("DEBUG, blyska zarowka %d %d\n", i,j);
						czy_rozblysla[i][j] = 1;
						cos_blyska = 1;
						ile_rozblyskow++;
						if(i+1<n) zarowki[i+1][j]+=1;
						if(i-1>=0) zarowki[i-1][j]+=1;
						if(j+1<n) zarowki[i][j+1]+=1;
						if(j-1>=0) zarowki[i][j-1]+=1;
						if(i+1<n && j+1<n) zarowki[i+1][j+1]+=1;
						if(i+1<n && j-1>=0) zarowki[i+1][j-1]+=1;
						if(i-1>=0 && j+1<n) zarowki[i-1][j+1]+=1;
						if(i-1>=0 && j-1>=0) zarowki[i-1][j-1]+=1;
					}
				}
			}
		}

		//sekwencja 3
		//zerowanie energii zarowek, ktore rozblysly
		//i resetowanie tablicy czy_rozblysla1
		for(int i=0; i<n; i++){
			for(int j=0; j<n; j++){
				if(zarowki[i][j] >= 10) zarowki[i][j] = 0;
				czy_rozblysla[i][j] = 0;
			}
		}

		//printf("DEBUG, zakonczyl sie %d krok\n", i+1);
	}

	//wypisywanie wyniku
	printf("%d\n", ile_rozblyskow);

	/*for(int i=0; i<n; i++){
		for(int j=0; j<n; j++){
			printf("%d ", czy_rozblysla[i][j]);
		}
		putchar('\n');
	}*/
	//putchar('\n');
	return 0;
}
