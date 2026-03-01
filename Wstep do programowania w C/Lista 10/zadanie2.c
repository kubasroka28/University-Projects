#include <stdio.h>
#include <limits.h>

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
//    printf("sum1: %d\n", sum1);
//    printf("sum2: %d\n", sum2);
//    printf("sum1 - sum2 = %d\n", sum1-sum2);
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
//    printf("evensum: %d\n", evensum);
//    printf("oddsum: %d\n", oddsum);
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

            //if(streak_for7 < 2) streak_for7 = 0;
        }
        else if(n%10 == 7){
            streak_for7 += 1;
            if(streak_for7 > max_streak_for7) max_streak_for7 = streak_for7;
            streak_for3 = 0;

            //if(streak_for3 <3) streak_for3 = 0;
        }
        else{
            streak_for3 = 0;
            streak_for7 = 0;

            //if(streak_for7 < 2) streak_for7 = 0;
            //if(streak_for3 <3) streak_for3 = 0;
        }
        n /= 10;
    }
//    printf("max streak of 7: %d\n", max_streak_for7);
//    printf("max streak of 3: %d\n", max_streak_for3);
    return (max_streak_for3 >= 3 && max_streak_for7 >= 2) ? 1 : 0;
}

int con3_3(long long int n){
    int streak_for3 = 0;
    while(n != 0){
        if(n%10 == 3){
            streak_for3 += 1;
            if(streak_for3 == 3) return 1;
        }
        else streak_for3 = 0;
        n /= 10;
    }
    return 0;
}

int con1string(long long n) {
    char num_str[20];
    sprintf(num_str, "%lld", n); // Convert number to string

    int sum = 0;
    for (int i = 0; i < 4 && num_str[i] != '\0'; i++) {
        sum += num_str[i] - '0'; // Convert character to integer and add to sum
    }

    return (sum % 22 == 0); // Check divisibility by 22
}

int main(){
    long long int x, y;
    //printf("%lld\n", LLONG_MAX);
    scanf("%lld%lld", &x, &y);
//    printf("x: %lld, y: %lld\n", x, y);
//    printf("is the sum of 4 first digits of x equal to 22: %d\n", con1(x));
//    printf("is the sum of 4 first digits of y equal to 22: %d\n", con1(y));
//    printf("is the con2 met for x? %d\n", con2(x));
//    printf("is the con2 met for y? %d\n", con2(y));
//    printf("is the con3 met for x? %d\n", con3(x));
//    printf("is the con3 met for y? %d\n", con3(y));

    printf("is the  con1string met for x? %d\n",  con1string(x));
    printf("is the  con1string met for y? %d\n",  con1string(y));

    int counter = 0;
    for(long long int i=x; i<=y; i++){
        if(con1(i) && con2(i) && con3(i)) counter++;
    }

    printf("%d\n", counter);

    return 0;
}
