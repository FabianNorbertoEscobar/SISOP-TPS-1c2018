#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>
#include <ctype.h>
#include <string.h>
#include <unistd.h>

#define PORT 5000

int configuracaoCliente(char *servidor)
{
    /*Descritor do cliente*/
    int clienteSockfd;
    /*Estrutura do Cliente*/
    struct sockaddr_in serv_addr;
    /*Tamanho da estrutura*/
    socklen_t addrlen = sizeof (serv_addr);
 
    /*Socket familia TCP declarado SOCK_STREAM e criado*/
    clienteSockfd = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (clienteSockfd < 0)
    {
        printf("Erro no Socket\n");
        exit(1);
    }
    /*Zera a estrutura*/
    bzero((char *) & serv_addr, sizeof (serv_addr));
    /*Seta a familia*/
    serv_addr.sin_family = AF_INET;
    /*Define o IP nesse caso o localhost*/
    //serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    serv_addr.sin_addr.s_addr = inet_addr(servidor);
    /*Define a porta de conexao*/
    serv_addr.sin_port = htons(PORT);

    /*Faz a conexao com o servidor*/
    if(connect(clienteSockfd,(struct sockaddr *)&serv_addr, addrlen) < 0)
    {
        printf("Erro no Socket\n");
        exit(1);
    }
    return clienteSockfd;
}
 
void Cliente(int clienteSockfd)
{
    char buffer_para_servidor[256],cad[256];
    int op,puntaje;
    //servidor pide nombre
    read(clienteSockfd, cad, sizeof (cad));
    printf("\n%s: ",cad);
    //envio nombre al servidor
    scanf("%s",buffer_para_servidor);
    write(clienteSockfd, buffer_para_servidor, sizeof (buffer_para_servidor));
    //bzero(cad,TAMBUF);
    //servidor envia msj bienvenida
    read(clienteSockfd, cad, sizeof (cad));
    printf("\n%s",cad);
    do {
        //servidor envia pregunta
        read(clienteSockfd, cad, sizeof (cad));
        printf("\n%s",cad);
        //servidor envia opciones
        read(clienteSockfd, cad, sizeof (cad));
        printf("\n%s",cad);
        printf("\nIngrese opcion elegida: ");
        scanf("%s", buffer_para_servidor);
        write(clienteSockfd, buffer_para_servidor, sizeof (buffer_para_servidor));
        //servidor envia validacion de respuesta
        read(clienteSockfd, cad, sizeof (cad));
        printf("%s\n",cad);
        //servidor envia si hay preguntas
        read(clienteSockfd, cad, sizeof (cad));
        if(strcmp(cad,"no hay preguntas") == 0)
        {
            strcpy(buffer_para_servidor,"salir");
            /*
            //servidor envia puntaje final
            read(clienteSockfd, cad, sizeof (cad));
            printf("El juego ha finalizado. %s\n",cad);
            */
        }
        //salir para finalizar
    } while (strcmp(buffer_para_servidor, "salir") != 0);
    close(clienteSockfd);
}
 
int main(int argc, char **argv)
{
    system("clear");
	printf("conectar a %s",argv[1]);
    /*Estrutura cliente*/
    struct sockaddr_in serv_addr;
    /*Tamanho da estrutura*/
    socklen_t addrlen = sizeof (serv_addr);
    /*Define o descritor cliente*/
    int descritorCliente;
    descritorCliente = configuracaoCliente(argv[1]);
    /*chama funcao do cliente passando o descritor*/
    Cliente(descritorCliente);
    exit(0);
}