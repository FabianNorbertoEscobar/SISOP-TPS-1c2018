#ifndef FUNCIONES_SERVIDOR_INCLUDED
#define FUNCIONES_SERVIDOR_INCLUDED

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <sys/resource.h>
#include "FuncionesServidor.c"
#include "cola.h"

void inicializarPreguntas(t_cola *);
void copiarOpciones(char *,char *);
int getPregunta(t_cola *,t_dato *);

#endif // FUNCIONES_SERVIDOR_INCLUDED 
