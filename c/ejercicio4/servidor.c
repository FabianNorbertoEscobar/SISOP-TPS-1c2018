
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>
#include <pthread.h>
#include <unistd.h>
#include "FuncionesServidor.h"
 
#define PORT 5000
#define MAX 5

t_dato PREGUNTA_ACTUAL;
t_cola cola;
int CONECTADOS = 0;

void* Servidor(void* arg)
{
    /*Buffer de entrada (armazena buffer do cliente)*/
    char buffer_do_cliente[256],cad[256];
    /*Cast do ponteiro*/
    int sockEntrada = *(int *) arg,op,puntos=0;
    /*Loop "infinito"*/
    printf("Esperando clientes... ");
    //pido nombre al cliente
    strcpy(cad,"Ingrese su nombre: ");
    write(sockEntrada,cad,sizeof(cad));

    //leo nombre cliente
    read(sockEntrada, buffer_do_cliente, sizeof (buffer_do_cliente));
    //envio msj de bienvenida
    strcpy(cad,"BIENVENIDO/A ");
    strcpy(cad,strcat(cad,buffer_do_cliente));
    write(sockEntrada,cad,sizeof(cad));

    for (;;)
    {
        //envia preguntas al cliente
        strcpy(cad,PREGUNTA_ACTUAL.pregunta);
        write(sockEntrada,cad,sizeof(cad)); 
        //envia opciones al cliente
        strcpy(cad,PREGUNTA_ACTUAL.opciones);
        write(sockEntrada,cad,sizeof(cad)); 
        //leo opcion elegida por el cliente
        read(sockEntrada, buffer_do_cliente, sizeof (buffer_do_cliente));

        if (strcmp(buffer_do_cliente, "salir") == 0)
        {
            CONECTADOS--;
            printf("\nSE HA DESCONECTADO UN CLIENTE, HAY %d CONECTADOS\n",CONECTADOS);
            /*Encerra o descritor*/
            close(sockEntrada);
            /*Encerra a thread*/
            pthread_exit((void*) 0);
        }
        else
        {
            //valido opcion elegida
            if(atoi(buffer_do_cliente) == PREGUNTA_ACTUAL.op_correcta)
            {
                strcpy(cad,"Opcion correcta\n");
                puntos++;
            }
            else
            {
                snprintf(cad,sizeof(cad),"Opcion incorrecta. La opcion correcta era la nro %d\n",PREGUNTA_ACTUAL.op_correcta);
                puntos--;
            }
            //envio respuesta
            write(sockEntrada,cad,sizeof(cad));
            if(noHayPreguntas(&cola) == 1)
                strcpy(cad,"no hay preguntas");
            else
            {
                strcpy(cad,"hay preguntas");
                getPregunta(&cola,&PREGUNTA_ACTUAL);
            }
            //envio si hay preguntas
            write(sockEntrada,cad,sizeof(cad));
            /*
            if(noHayPreguntas(&cola) == 1)
            {
                snprintf(cad,sizeof(cad),"Su puntaje final es %d puntos",puntos);
                //envio puntaje fina
                write(sockEntrada,cad,sizeof(cad));
            }*/
        }
    }
}
 
int configuracaoServidor()
{
    /*Cria o descritor*/
    int sockfd;
    /*Declaracao da estrutura*/
    struct sockaddr_in serverAddr;
    /*Cria o socket*/
    if ((sockfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) < 0)
    {
      printf("Error en el Socket\n");
      exit(1);
    }
    /*Zera a estrutura*/
    memset(&serverAddr, 0, sizeof (serverAddr));
    /*Seta a familia*/
    serverAddr.sin_family = AF_INET;
    /*Seta os IPS (A constante INADDR_ANY e todos os ips ou qualquer ip) htonl -> conversao*/
    serverAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    /*Define a porta*/
    serverAddr.sin_port = htons(PORT);
    /*Faz a bindagem (cola, gruda, conecta seja o que for)*/
    if (bind(sockfd, (struct sockaddr *) & serverAddr, sizeof (serverAddr)) < 0)
    {
      printf("Erro no Socket\n");
      exit(1);
     }
    /*Fica na escuta de ate 5 clientes*/
    if (listen(sockfd, MAX) < 0)
    {
      printf("Error en Socket\n");
      exit(1);
    }
    return sockfd;
}
 
int main()
{
    system("clear");

	inicializarPreguntas(&cola);
    
    getPregunta(&cola,&PREGUNTA_ACTUAL);
    struct sockaddr_in serverAddr;
    int sockfd = configuracaoServidor();

    while (1)
    {
        int clienteSockfd;
        struct sockaddr_in clienteAddr;
        /*tamanho da estrutura*/
        unsigned int clntLen;
        clntLen = sizeof (clienteAddr);
        /*declara uma thread*/
        pthread_t thread;
        /*Fica no aguardo da conexao do cliente*/
        if ((clienteSockfd = accept(sockfd, (struct sockaddr *) & clienteAddr, &clntLen)) < 0)
        {
            printf("Erro no Socket\n");
            exit(1);
        }
        /*Inicializa a thread*/
        if (pthread_create(&thread, NULL, Servidor, &clienteSockfd) != 0)
        {
            printf("Erro na Thread\n");
            exit(1);
        }
        printf("\nNUEVO CLIENTE CONECTADO\n");
        CONECTADOS++;
        printf("%d clientes conectados\n",CONECTADOS);
        pthread_detach(thread);
    }
    exit(0);
}