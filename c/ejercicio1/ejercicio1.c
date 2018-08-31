#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>
#include <sys/prctl.h>

//funcion controladora de señales
void my_handler(int signum)
{
	//Atrapa solo SIGUSR1
    if (signum == SIGUSR1)
    {
		//para este ejercicio no necesito que haga nada
    }
}
////////////////////////////////////////////////////////

//////////////////Proceso main////////////////
int main()
{
	//Numero a asignar para identificar si es abuelo, padre, hijo, etc.
	int generacion = 0;
	
	//Cadena para imprimir el nombre del parentesco de cada proceso
	char parentesco[10];
	
    //Numero unico para cada proceso
	int numero = 0;
	
	//pid actual
	pid_t pid ;
	//pid padre
    pid_t ppid ;
    //pid hijo 1
	pid_t pid1 = 0 ;
    //pid hijo 2
	pid_t pid2 = 0 ;
	
	//////Creacion de procesos//////////
	for(int i=1;i<3;i++)
	{
		if ( generacion < 4 && numero < 12 )
		{	
            //se divide la ejecucion, fork devuelve el pid del hijo en el padre, 0 en el hijo, y -1 si hay error
			pid = fork();
			
			if ( pid == -1 ){
				printf("Error al crear nuevo proceso !!!");
					   return 1;
			}
			
			if ( pid == 0 ) {
                //formula para calcular el numero unico de este proceso
				numero = ( numero * 2 ) + i ;
				generacion ++;				
				i=0;								
			}
			
			if ( pid > 0 ) {
				if ( i == 1 ) {
                    //Guarda el pid del primer hijo
					pid1 = pid;							
				}
				else{
                    //Guarda el pid del segundo hijo
					pid2 = pid;
				}
			}
		}
	}
	//////////////////////////////////////
	
	///////////Switch para escribir el parentesco//////////////// 
	switch (generacion)
	{
		case 0 :
         strcpy(parentesco, "Abuelo");
         break;
		case 1 :
         strcpy(parentesco, "Padre");
         break;
		case 2 :
         strcpy(parentesco, "Hijo");
         break;
		case 3 :
         strcpy(parentesco, "Nieto");
		 break;
		case 4 :
         strcpy(parentesco, "Bisnieto");
         break;
      default :	
		strcpy(parentesco, "No se");
	}
	//////////////////////////////////////////////////////
	
	///////////en el caso de que sea el Zombie////////////
	if ( numero == 7 || numero > 19 ){
		strcpy(parentesco, "Zombie");
	}
	//////////////////////////////////////////////////////
	
	/////En el caso de que sea el Demonio/////////////////
	if ( numero == 15 || numero == 16 ){
		strcpy(parentesco, "Demonio");
	}
    /////////////////////////////////////////////////////
	
	//Conseguir pid actual
    pid = getpid();
	//Conseguir pid padre
    ppid = getppid();
	
	//Imprimo Parentesco/Tipo: [nieto, hijo, zombie]
	printf( "Soy el proceso con PID %d y pertenezco a la generación No %d\nPid: %d Pid padre: %d Parentesco/Tipo: %s\n", pid, generacion, pid, ppid, parentesco);
		
	if ( generacion == 0 ){		
		//////////////////////Proceso principal//////////////////////
        //espera el ingreso de un Enter
		getchar();
        //manda señales a los dos hijos para que salgan de su posible suspension
		kill(pid1, SIGUSR1);
		kill(pid2, SIGUSR1);		
	}
	else{
		//////////////////////Procesos Zombie///////////////////////
		if ( numero == 7 || numero > 19 ){
			exit(0);                       //Procesos Zombie salen inmediatamente
		}
		else{
	    //////////////////////Procesos Demonio//////////////////////
			if ( numero == 15 || numero == 16 ){
				setsid();
				sleep(240);                //Procesos Demonio esperan 4 minutos y despues terminan
			}
			else{
				/////////////////Procesos Padre,Hijos,Nietos,Bisnietos//////////////
				
				////Lo que sigue es para que estos procesos no terminen////
				////hasta que el proceso principal termine             ////
								
                //Establece la señal controladora para SIGUSR1
                signal(SIGUSR1, &my_handler);
                //declara un set de señales
                sigset_t sigset;
                //inicializa el set vacio
                sigemptyset(&sigset);
                //agrega la señal SIGUSR1 al set
                sigaddset(&sigset, SIGUSR1);
                //bloquea todas las señales del set "sigset"
                sigprocmask(SIG_BLOCK, &sigset, NULL);   
                //declara un int auxiliar, para que sigwait guarde el numero de señal que recibio
                int sig;
				
                //suspende el proceso hasta que recibe una de las señales dentro del sigset
                sigwait(&sigset, &sig);
				
                //despues de recibir la señal desbloquear las señales
                sigprocmask(SIG_UNBLOCK, &sigset, NULL);
                
                //manda señales a los dos hijos para que salgan de su posible suspension
				kill(pid1, SIGUSR1);
				kill(pid2, SIGUSR1);
				
                //Espera las respuestas de los hijos
				wait( NULL );
				wait( NULL );
                
			}
		}
	}
		
	return 0;
}
