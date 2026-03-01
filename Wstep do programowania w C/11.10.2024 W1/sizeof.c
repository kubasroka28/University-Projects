#include <stdio.h>
#include <limits.h>

int main(void) {
  printf("%zd %zd %zd\n", sizeof(int),   sizeof(long),   sizeof(long long));
  printf("%zd %zd %zd\n", sizeof(float), sizeof(double), sizeof(long double));
  printf("%ld\n", LONG_MIN);
  return 0;
}
