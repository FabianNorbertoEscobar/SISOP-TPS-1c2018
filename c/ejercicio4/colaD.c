#include "colaD.h"

void crearColaD(tCola *p)
{
    p->pri = NULL;
    p->ult = NULL;
}
int colaLlenaD(const tCola *p)
{
    tNodo *nue = (tNodo *)malloc(sizeof(tNodo));
    free(nue);
    return  nue == NULL;
}
int colaVaciaD(const tCola *p)
{
    return p->pri == NULL && p->ult == NULL;
}
int ponerEnColaD(tCola *p, const tInfo *d)
{
    tNodo *nue = (tNodo *)malloc(sizeof(tNodo));
    if(nue == NULL)
        return 0;
    nue->info = *d;
    nue->sig = NULL;
    if(p->pri == NULL)
        p->pri = nue;
    if(p->ult != NULL)
        (p->ult)->sig = nue;
    p->ult = nue;
    return 1;
}
int sacarDeColaD(tCola *p, tInfo *d)
{
    if(p->pri == NULL && p->ult == NULL)
        return 0;
    tNodo *elim = p->pri;
    *d = elim->info;
    p->pri = elim->sig;
    free(elim);
    return 1;
}
void vaciarColaD(tCola *p);
int frenteDeColaD(const tCola *p, tInfo *d)
{
    if(p->pri == NULL && p->ult == NULL)
        return 0;
    tNodo *elim = p->pri;
    *d = elim->info;
    return 1;
}
