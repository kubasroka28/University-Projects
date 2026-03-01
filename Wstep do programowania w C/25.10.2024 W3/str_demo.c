#include <stdio.h>
#include <ctype.h>

int main (void) {
    char napis[200] = "Hello, world!\n";
    napis[8] = toupper(napis[1]);
    puts(napis);
    /* Na standardowe wyjscie zostaja wypisane DWA znaki konca wiersza - jeden
     * pojawiajacy sie jawnie w literale napisowym uzytym do inicjalizacji
     * zmiennej napis i drugi "dodawany" zawsze przez funkcję puts. Pokrewna
     * funkcja fputs(napis, stdout) nic nie "dodaje", a w dodatku wymaga
     * drugiego argumentu mowiacego, na jaki potok ma zostac wypisany napis.
     * stdout to identyfikator zdefiniowany w stdio.h oznaczajacy standardowe
     * wyjscie, jest tam tez stdin (oraz stderr).
     */
    return 0;
}
