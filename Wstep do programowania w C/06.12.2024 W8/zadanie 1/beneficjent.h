// --------------Plik naglowkowy--------------

#include <stdlib.h>
#include <string.h>
#include <stdint.h>

// --------------Prototypy typow zlozonych--------------

struct Osoba
{
	char* imie;
	uint8_t wiek;
	unsigned int zaslugi;
	unsigned int szelmostwa;
};

// --------------Prototypy funkcji--------------

struct	Osoba* nowa_osoba(char* imie, uint8_t wiek);
void	usun_osobe(struct Osoba* osoba);
void	zmien_imie(struct Osoba* osoba, char* imie);
void	zmien_wiek(struct Osoba* osoba, uint8_t wiek);
void	dodaj_zasluge(struct Osoba* osoba);
void    dodaj_szelmostwo(struct Osoba* osoba);
void	ustaw_statystyki(struct Osoba* osoba, unsigned int zaslugi, unsigned int szelmostwa);
int	    czy_dostanie_prezent(struct Osoba* osoba);
void	wypisz_info(struct Osoba* osoba);
int	    komparator(struct Osoba* os1, struct Osoba* os2);
