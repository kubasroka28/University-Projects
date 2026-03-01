#include <stdio.h>
#include <limits.h>
#include <string.h>
#include <stdlib.h>

int con1(long long int n){
    long long int i = n;
    int sum1 = 0;
    int sum2 = 0;
    int counter = 0;
    while(i != 0){
        sum1 += i%10;
        i /= 10;
        counter++;
    }
    for(i=0; i<counter-4; i++){
        sum2 += n%10;
        n /= 10;
    }
    return (sum1-sum2==22) ? 1 : 0;
}

int con2(long long int n){
    long long int i = n;
    int evensum = 0;
    int oddsum = 0;
    while(i != 0){
        evensum += i%10;
        i /= 10;
        oddsum += i%10;
        i /= 10;
    }
    return (evensum - oddsum >= 19) ? 1 : 0;
}

int con3(long long int n){
    int streak_for7 = 0, streak_for3 = 0;
    int max_streak_for7 =0, max_streak_for3 = 0;
    while(n != 0){
        if(n%10 == 3){
            streak_for3 += 1;
            if(streak_for3 > max_streak_for3) max_streak_for3 = streak_for3;
            streak_for7 = 0;
        }
        else if(n%10 == 7){
            streak_for7 += 1;
            if(streak_for7 > max_streak_for7) max_streak_for7 = streak_for7;
            streak_for3 = 0;
        }
        else{
            streak_for3 = 0;
            streak_for7 = 0;
        }
        n /= 10;
    }
    return (max_streak_for3 >= 3 && max_streak_for7 >= 2) ? 1 : 0;
}

int czy_warto(char* n){
    //if(con1(atoll(n)) && con2(atoll(n)) && con3(atoll(n))) return 1;

    return 1;
}

int main(){
    char x[14], y[14], z[14]={0};
    scanf("%s%s", &x, &y);
    strcpy(z,x);
    puts(x);
    puts(y);
    puts(z);
    int pozycja=strlen(z)-1;
//    printf("liczba cyfr x to:%d\n",pozycja);
//    x[pozycja]++;
//    puts(x);

    z[pozycja]--; //????
    int licznik=0;
    while(pozycja>=0){
        while(pozycja>=0 && pozycja<strlen(y)){
            z[pozycja]++;
            while(z[pozycja]<='9' && !czy_warto(z)){
                z[pozycja]++;
                if(strcmp(z,y)>=0) break;
            }
            if(strcmp(z,y)>=0) break;

            /*do
                z[pozycja]++;
                if(atoi(z)>atoi(y))continue;
            while(z[pozycja]<='9' && !czy_warto(z));
            if(atoi(z)>atoi(y))break;*/

            if(z[pozycja]<='9'){
                pozycja++;
                if(pozycja<strlen(y)) z[pozycja] = '0'-1;
                else pozycja--;
                //z[pozycja] = '0'-1;     //potencjalnie odwolywanie sie do juz nieistniejacej komorki
            }
            else{
                z[pozycja] = '\0';
                pozycja--;
            }
        }

        if(con1(atoll(z)) && con2(atoll(z)) && con3(atoll(z))){

            puts(z);
            licznik++;
        }

    }

    return 0;
}

