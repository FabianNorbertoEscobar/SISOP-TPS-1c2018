#!/bin/bash
if test $1 = "-?" -o $1 = "-h" -o $1 = "-help"
then
	echo "	
	Sinopsis:

	Nombre del archivo: Ejercicio6.sh
	Trabajo práctico: 2
	Ejercicio: 5
	Autores:
	    - Buzzoni, Ariel - DNI: 41.138.235
	    - Corno, Ezequiel - DNI: 39.430.288
	    - Escobar, Fabián - DNI: 39.210.915
	    - Pereira, Matias - DNI: 37.341.055
	    - Rossi, Alan - DNI: 37.250.221
	Entrega: #1 ENTREGA - 2018/23/05

	Descripcion:

	El script recibe como parámetro la ruta y nombre de un archivo de log y permanece en
	segundo plano capturando las señales SIGUSR1 y SIGUSR2, para las cuales se debe realizar las
	acciones que se describen a continuación, el resto de las señales deben ser ignoradas:
	SIGUSR1: Realizar un backup comprimiendo todos los archivos y directorios que se encuentren
	dentro de la ruta indicada por la variable de entorno PATH_ENTRADA y guardar el archivo comprimido
	en el directorio indicado por la variable de entorno PATH_SALIDA. El nombre del archivo de salida
	debe ser el nombre del directorio concatenándole la fecha y hora al momento de la compresión.
	Además, deberá registrar en el fichero de log la fecha y hora de ejecución, la cantidad de archivos
	comprimidos y el peso del archivo final.
	SIGUSR2: Elimina todos los archivos que se encuentren dentro de la variable de entorno
	PATH_SALIDA. Debe registrar en el fichero de log la fecha y hora de ejecución, cantidad de archivos
	eliminados y el espacio de disco liberado.
	El script finaliza la ejecución al recibir la señal SIGTERM."

	exit 1
fi
echo "PID del proceso en background: $$"

# Señales: SIGUSR1: 10, SIGUSR2: 12, SIGTERM: 15

function salir {
 # Elimina el archivo de lockeo y termina
 rm -f $1
 echo "Fin"
 exit
}

function hacerBackup {
 rutaEjecucion=$PWD
 cd "$PATH_ENTRADA"

 cantArchivos=$(find . -type f -readable | wc -l)
 fecha=$(date +%d-%m-%Y_%H:%M)
 zip -r "$PATH_SALIDA/$(basename "$PATH_SALIDA")_$fecha.zip" .
 tam=$(find "$PATH_SALIDA" -type f -readable -name "$(basename "$PATH_SALIDA")_$fecha.zip" -printf '%s')
 
 cd "$rutaEjecucion"

 echo "$fecha Archivos guardados: $cantArchivos. Tam archivo backup: $tam bytes." >> "$*"
}


function eliminarArchivos {  
 cantArchivos=0
 tam=0
 for i in $(find "$PATH_SALIDA" -type f -printf '%s ') # printf %s devuelve el tam en bytes
  do
   tam=$(($tam+$i))
   cantArchivos=$(($cantArchivos+1))
  done
 
 find "$PATH_SALIDA" -type f -delete
 
 fecha=$(date +%d-%m-%Y_%H:%M)
 echo "$fecha Archivos eliminados: $cantArchivos. Tam en disco liberado: $tam bytes." >> "$*"
}

# Señales que ignora
trap "echo 'ignorado'" SIGHUP 
trap "echo 'ignorado'" SIGCONT
trap "echo 'ignorado'" SIGTSTP

# Señales que maneja
trap "hacerBackup $1" SIGUSR1
trap "eliminarArchivos $1"  SIGUSR2
trap 'salir $2' SIGTERM

# Esto para que el script no termine y quede recibiendo señales
while [ true ]; do
$a;
done
