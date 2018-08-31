#include<sys/types.h>
#include<sys/stat.h>
#include<fcntl.h>
#include<unistd.h>
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include<time.h>

void ayuda(){
  printf("INTEGRANTES: \n");
  printf("CORNO, EZEQUIEL DNI:39.430.288\n");
  printf("VILLALBA, GUILLERMO DNI:32.944.121\n");
  printf("PEREIRA, MATIAS DNI:37.341.055\n");
  printf("BUZZONI, ARIEL DNI:41.138.235\n");
  printf("ESCOBAR, FABIAN DNI:39.210915\n");
  printf("---------------\nejercicio5.out -h\nejercicio5.out -help\nejercicio5.out -? :\n\t\t muestran esta ayuda\n\n");
  printf("---------------\nejercicio5.out nombre_FIFO tamaño_etiqueta directorio_destino  :  \n\n");
  printf("\t\tEn esta forma el programa se ejecuta como un proceso demonio, ofreciendo un servicio de clasificación de registros ");
  printf("recibidos, como string, a través de un FIFO, y guarda en distintos archivos los registros de entrada en función ");
  printf(" de la etiqueta de clasificación del mismo. Las etiquetas de clasificación son los primeros N caracteres del ");
  printf("registro recibido N como segundo parametro.\n");
  printf("\t\tCada archivo de clasificación tendrá un nombre conformado por las distintas etiquetas procesadas concatenada a");
  printf(" la fecha de proceso ([etiqueta]_yyyymmdd).\n");
  printf("\t\tDebe recibir por parámetro primero el nombre del FIFO, segundo tamaño de la etiqueta y tercero el directorio de");
  printf(" destino. Tanto el FIFO como los archivos de clasificacion se crean en el directorio de destino. Al finalizar el ");
  printf("proceso el fifo se destruye. Pueden existir varios procesos al mismo tiempo sobre el mismo directorio con distintos FIFOs");
  printf(", o en distintos directorios con el mismo nombre de fifo, pero no pueden haber dos procesos en el mismo directorio con el ");
  printf("mismo nombre de FIFO. Finalmente el proceso muestra por pantalla el PID del proceso para poder finalizarlo luego.\n\n");
}

void signalHandler( int );

int validar_parametros(char *par1, char *par2, char *par3){
  
  if(par1[0] == '\0')
  {
    printf("el nombre del fifo no puede ser vacio\n");
    return 1;
  }
  
  if( atoi(par2) <= 0 || atoi(par2) > 25 )
  {
    printf("el tamaño de la etiqueta debe ser mayor a 0 y menor a 25\n");
    return 1;
  }
  
  if( chdir(par3) )
  {
    printf("el nombre del path debe ser valido\n");
    return 1;
  }
  
  struct stat buffer;  
  if( stat(par1,&buffer) >= 0 )
  {
    printf("el nombre del fifo ya existe en el path\n");
    return 1;
  }
    
  return 0;
}

/* Variables globales para cerrar la tuberia fifo cuando se atrapa una señal kill o sigterm */
int fd=0;
char *fifo = NULL ;

//argc : cuenta los argumentos, argc == 1 seria que no tiene argumentos
//argv son punteros a los argumentos recibidos,arg[0] es el nombre del programa, argv[1] seria el primer argumento si hubiera
int main(int argc , char *argv[])
{
  /////////////verificcion de parametros////////////////
  switch (argc)
  {
    case 1:
      printf("Faltan argumentos\n");
      return 1;
    case 2:
      if( strcmp(argv[1], "-h" ) == 0  || strcmp(argv[1],"-help") == 0 || strcmp(argv[1],"-?") == 0 ){
        ayuda();
        return 0;
      }
      printf("Argumento invalido use -h\n");
      return 2;
    case 4:
      if(validar_parametros(argv[1],argv[2],argv[3]) != 0)
      {
        return 4;
      }
      break;
    default :
      printf("Verifique sintaxis de parametros con -h.\n");
      return 3;
  }
  //***************************************************
  
  ///////////////Creacion del proceso demonio//////////
  int pid;
  pid = fork();
  
  if (pid < 0) {
    exit(EXIT_FAILURE);
  }
  
   if (pid > 0) {
     printf("Demonio corriendo Finalizar con 'KILL %d'\n", pid );
     exit(EXIT_SUCCESS);
  }
  
   /* Cambia el modo de la mascara de ficheros para que los ficheros 
      generados por el demonio sean accesibles por todo el mundo */
  umask(0);
  
  /*Se le da un nuevo sid al proceso para que no dependa de la consola*/
  int sid = setsid();
  if (sid < 0) {
    perror("fallo otorgar nuevo SID\n");
    exit(EXIT_FAILURE);
  }
  
  /* Cerramos los descriptores standard */
  close(STDIN_FILENO);
  close(STDOUT_FILENO);
  close(STDERR_FILENO);
  
  //******************************************
  
  /////////////obtener fecha//////////////////
  
  time_t t = time(NULL);
  struct tm tm = *localtime(&t);
  char fecha[14];  
  sprintf(fecha,"_%d%02d%02d", tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday );
  
  //*****************************************
    
  ////////////crea fifo//////////////////////
  
  mkfifo(argv[1], 0660 );
  fd=open(argv[1], O_RDWR);     //abro el fifo en modo lectura escritura para que permanesca abierto aunque no se abra desde otro proceso
  
  /* cargar nombre de fifo en variable*/
  fifo = argv[1];
  
  //*****************************************
  
  ////atrapar señales para cerrar el fifo al terminar////
  
  signal(SIGINT, signalHandler);
  signal(SIGTERM, signalHandler);
  signal(SIGQUIT, signalHandler);
  
  //*****************************************************
    
  /////////////variables auxiliares/////////////////////
  
  int N_etiqueta = atoi(argv[2]);   //guardo el tamaño de la etiqueta en un int
  char registro[256];               //buffer de lectura para registro
  registro[256] = '\0';             //inicializo el buffer vacio
  FILE * archivo;                   //para abrir y grabar los registros
	char etiqueta[35];                //para guardar la etiqueta de cada iteracion
  char cad = 'c';                   //para leer de a un caracter el fifo
  int aux_etiqueta;                 //para iterar etiqueta
  int aux_registro;                 //para iterar registro
  
  //***************************************************
  
  ///////////loop de lectura de la cola fifo///////////
  
  while( 1 )
  {
    aux_etiqueta=0;         //inicializo en 0
    etiqueta[0] = '\0';     //inicializo etiqueta vacia
    
    aux_registro= 0;        //inicializo en 0
    registro[0] = '\0';     //inicializo registro vacio
    
    do
    {
      read(fd, &cad, sizeof(char));
      etiqueta[aux_etiqueta] = cad;
      aux_etiqueta++;
    
    }while( aux_etiqueta < N_etiqueta && cad != '\0' ); //leo el fifo de a un char hasta el tamaño de la etiqueta o el caracter nulo
    
    etiqueta[aux_etiqueta] = '\0' ;           //marco el final de la etiqueta
    strcat(etiqueta,fecha);                   //agrego a la etiqueta la fecha para componer el nombre archivo de clasificacion
        
    if(cad != '\0'){                      //en caso de haber encontrado el caracter nulo graba el caracter nulo
     do
      {
       read(fd, &cad, sizeof(char));
       registro[aux_registro] = cad;
       aux_registro++;
     
      }while( aux_registro <256 && cad != '\0' );     //leo el fifo hasta 255 chars o el caracter nulo para obtener el registro
    }
    
    archivo = fopen (etiqueta, "a");          //abrir en modo apend el archivo de clasificacion (si no existe lo crea)        
    fprintf(archivo, "%s\n", registro);       //graba el registro
    fclose(archivo);                          //cerrar el archivo
    
  }
  
  //****************************************************************
  	  
  return 0;
}

////////funcion para manejar las señales//////////

void signalHandler( int dummy){   //funcion que se dispara al atrapar las señales que cierran el proceso
  close(fd);                      //cierra el fifo
  unlink(fifo);                   //destruye el fifo
  exit(0);                        //finaliza el proceso
}  

//************************************************