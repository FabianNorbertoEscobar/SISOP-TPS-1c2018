#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/shm.h>
#include <stdlib.h>
void encriptar(char*cad,int nro);
void desencriptar(char*cad,int nro);
int main()
{
  key_t clave;
  int id_memoria;
  char *memoria=NULL;
  int op,nro;
  clave=ftok("/bin/ls",55);
  printf("Se utiliza el cifrado Cesar que mueve cada letra un determinado numero de espacios en el alfabeto\n");
  
  
if(clave== -1)
    {
      printf("no consigo clave para memoria compartida");
      exit(0);
    }
   

   
id_memoria=shmget(clave,sizeof(char),0777| IPC_CREAT);
   
if(id_memoria==-1)
    {
     printf("no consigo id para memoria compartida");
     exit(0);
    }
    

    
memoria=(char*)shmat(id_memoria,(char *)0,0);
    
if(memoria==NULL)
    {
     printf("no consigo memoria compartida");
     exit(0);
    }


printf("--------------MENU----------------\n");
printf("Opcion1(encriptar)\n");
printf("Opcion2(desencriptar)\n");
printf("Opcion3(exit)\n");
printf("Opcion4(help)\n");
printf("ingrese una opcion(1,2,3,4):");
scanf("%d",&op);
while(op!=3)
{
    if(op==1)
{
  printf("ingrese un mensaje para encriptar:");
  scanf("%s",memoria);
  printf("ingrese un nro:");
  scanf("%d",&nro);
  encriptar(memoria,nro); 
  printf("mensaje encriptado:%s\n",memoria);
   
}
    if(op==2)
{
  printf("ingrese un mensaje para desencriptar:");
  scanf("%s",memoria);
  printf("ingrese un nro:");
  scanf("%d",&nro);
  desencriptar(memoria,nro);
  printf("mensaje desencriptado:%s\n",memoria);
 
}
	if(op==4)
{
  printf("INTEGRANTES: \n");
  printf("CORNO, EZEQUIEL DNI:39.430.288\n");
  printf("VILLALBA, GUILLERMO DNI:32.944.121\n");
  printf("PEREIRA, MATIAS DNI:37.341.055\n");
  printf("BUZZONI, ARIEL DNI:41.138.235\n");
  printf("ESCOBAR, FABIAN DNI:39.210915\n");
}

printf("--------------MENU----------------\n");
printf("Opcion1(encriptar)\n");
printf("Opcion2(desencriptar)\n");
printf("Opcion3(exit)\n");
printf("Opcion4(help)\n");
printf("ingrese una opcion(1,2,3,4):");
scanf("%d",&op);
}
shmdt(memoria);
shmctl(id_memoria,IPC_RMID,NULL);
return 0;
}



void encriptar(char*cad,int nro)
{char*aux;
 while(*cad)
 {
   if(*cad!=' ')
   {
       *cad=*cad+nro;
    if(*cad>'z')
    {
       *cad='a'-1+(*cad-'z');
    }


   }
   cad++;
 } 

}
void desencriptar(char*cad,int nro)
{
  while(*cad)
 {
   if(*cad!=' ')
 {
  *cad=*cad-nro;
  if(*cad<'a')
  {
    *cad='z'+1-('a'-*cad);
  }
 }
  cad++;
 } 
}
