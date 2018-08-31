#ifndef COLAD_H_INCLUDED
#define COLAD_H_INCLUDED

#include "../main.h"

typedef int tInfo;

typedef struct sNodo
{
    tInfo info;
    struct sNodo *sig;
}tNodo;

typedef tNodo *tPilaD;

void crearColaD(tCola *p);
int colaLlenaD(const tCola *p);
int colaVaciaD(const tCola *p);
int ponerEnColaD(tCola *p, const tInfo *d);
int sacarDeColaD(tCola *p, tInfo *d);
void vaciarColaD(tCola *p);
int frenteDeColaD(const tCola *p, tInfo *d);

#endif // COLAD_H_INCLUDED
