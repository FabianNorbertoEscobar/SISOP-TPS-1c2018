#include "FuncionesServidor.h"
#include "cola.c"
#include <string.h>

typedef struct {
    char tipo,texto[200];
}t_registro;
void copiarOpciones(char *opciones,char *texto)
{
	if(strcmp(opciones,"") == 0)
		strcpy(opciones,texto);
	else
		strcat(opciones,texto);
}
void inicializarPreguntas(t_cola *cola)
{
	//t_cola cola;
	char string[200],cadena[200];
	int i,j=0,cont=0;

	crear_cola(cola);
	if(cola_llena(cola) == 1)
		printf("COLA LLENA\n");

	FILE *fp;	 
	fp = fopen("preguntas.txt", "r"); // read mode
	 
	if (fp == NULL)
	{
		perror("Error while opening the file.\n");
		exit(EXIT_FAILURE);
	}

	t_dato pregunta;
	t_registro registro;
	int nro_opcion = 1;
	pregunta.nro_pregunta = 0;
	//printf("The contents of preguntas.txt file are:\n");
	while(fgets(string, 200, fp)) {
		sscanf(string,"%c|%[^|\n]",&registro.tipo,registro.texto);
		//printf("tipo: %c text: %s\n",registro.tipo,registro.texto);
		if(registro.tipo == 'P')
		{
			if(pregunta.nro_pregunta != 0)
			{
				//strcpy(pregunta.opciones,opciones);
				poner_en_cola(cola,&pregunta);
				pregunta.op_correcta = 0;
				nro_opcion = 1;
				strcpy(pregunta.pregunta,"");
				strcpy(pregunta.opciones,"");
			}
			strcpy(pregunta.pregunta,registro.texto);
			pregunta.nro_pregunta++;
		}
		else if(registro.tipo == 'R')
		{
			strcat(registro.texto,"\n");
			copiarOpciones(pregunta.opciones,registro.texto);
			nro_opcion++;
		}
		else if(registro.tipo == 'C')
		{
			strcat(registro.texto,"\n");
			pregunta.op_correcta = nro_opcion;
			copiarOpciones(pregunta.opciones,registro.texto);
		}
		cont++;
		
	}
	//strcpy(pregunta.opciones,opciones);
	poner_en_cola(cola,&pregunta);
	/*
	if(cola_vacia(cola) == 0 && cola_llena(cola) == 0)
		printf("no esta vacia ni llena\n");
	else
		printf("esta vacia o llena\n");
	while(!cola_vacia(cola))
	{
		sacar_de_cola(cola,&pregunta);
		printf("nro pregunta: %d\n",pregunta.nro_pregunta);
		printf("pregunta: %s\n",pregunta.pregunta);
		printf("correcta: %d\n",pregunta.op_correcta);
		printf("opciones: %s\n",pregunta.opciones);
	}
	*/
	fclose(fp);
}
int getPregunta(t_cola *cola,t_dato *dato)
{
	return sacar_de_cola(cola,dato);
}
int noHayPreguntas(t_cola *cola)
{
	return cola_vacia(cola);	
}