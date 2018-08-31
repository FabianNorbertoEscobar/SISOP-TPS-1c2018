#include <stdlib.h>
#include "cola.h"
#include <string.h>

void crear_cola(t_cola * pc){
    pc->fdo = NULL;
    pc->fte = NULL;
}

int poner_en_cola(t_cola * pc,const t_dato* cd){
    t_nodo * pnue = (t_nodo*)malloc(sizeof(t_nodo));
    if(!pnue) return 0;
    pnue->dato = *cd;
    pnue->psig = NULL;
    if(pc->fte == NULL) pc->fte = pnue;
    else pc->fdo->psig = pnue;
    pc->fdo = pnue;
    return 1;
}

int sacar_de_cola(t_cola * pc,t_dato * cd){
    if(pc->fte == NULL) return 0;
    t_nodo *aux = pc->fte;
    *cd = pc->fte->dato;
    pc->fte = pc->fte->psig;
    free(aux);
    if(!pc->fte) pc->fdo = NULL;
    return 1;
}

int frente_cola(const t_cola * pc,t_dato * cd){
    if(pc->fte == NULL) return 0;
    *cd = pc->fte->dato;
    return 1;
}

int cola_llena(const t_cola * pc){
    t_dato * pnue;
    pnue = malloc(sizeof(t_dato));
    free(pnue);
    return pnue == NULL;
}

int cola_vacia(const t_cola * pc){
    if(pc->fte == NULL && pc->fdo == NULL) return 1;
    return 0;
}

void vaciar_cola(t_cola * pc){
    while(pc->fte){
        t_nodo *aux;
        aux = pc->fte;
        pc->fte = pc->fte->psig;
        free(aux);
    }
    pc->fdo = NULL;
}
