#include <stdio.h>

int main(void) {
  int i, t[64];
  for (i = 0; i < 64; i++) {
    printf("%8x", t[i]);
    putchar((i + 1) % 8 ? '|' : '\n');
  }
  putchar('\n');
  return 0;
}
