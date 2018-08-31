#!/bin/bash
# se atiende la solicitud de la ayuda del script
if test $1 = "-?" -o $1 = "-h" -o $1 = "-help"
then
	echo "	
	Sinopsis:

	Nombre del archivo: Ejercicio4.sh
	Trabajo práctico: 2
	Ejercicio: 4
	Autores:
	    - Buzzoni, Ariel - DNI: 41.138.235
	    - Corno, Ezequiel - DNI: 39.430.288
	    - Escobar, Fabián - DNI: 39.210.915
	    - Pereira, Matias - DNI: 37.341.055
	    - Rossi, Alan - DNI: 37.250.221
	Entrega: #1 ENTREGA - 2018/23/05

	Descripcion:
	
	El script realiza el control del horario de trabajo de los empleados de una empresa.
	A partir de un archivo log que contiene un reporte de las fichadas de cada trabajador en el mes,
	puede generar para cada trabajador un reporte de horas trabajadas
	y escribirlo en un archivo reg mostrarlo por pantalla (opcionalmente),
	o solo mostrar por pantalla las horas teóricas, las horas trabajadas y las horas extra.

	Parámetros:

	-r: Solicita la generación del reporte de horas en un archivo .reg para cada legajo

	-p: Solicita el informe por pantalla los legajos procesados y la cantidad de horas trabajadas de cada uno
	(Éste parámetro solo puede ser enviado a continuación del parámetro -r, sino se informa error de parámetros)
	
	-l: Solicita el informe por pantalla de las horas teóricas, trabajadas y extra de un legajo pasado a continuación
	sin la generación del archivo reg

	Ejemplo:

	$./Ejercicio4.sh ./reporteA.log -r
	$./Ejercicio4.sh ./reporteA.log -r -p
	$./Ejercicio4.sh ./reporteA.log -l 001021

	Entradas:

	Archivo log con el reporte de las fichadas de los trabajadores

	Salidas:

	Archivo reg con el reporte de las horas trabajadas por cada legajo

	Notas:

	Las horas teóricas trabajadas son 176 (22 días hábiles por 8 horas laborales)

	"

	exit 1
fi


# se valida que se haya ingresado la cantidad mínima de parámetros
if test $# -lt 2
then
	echo "Al menos debe ingresarse dos parámetros (el path del archivo log y algún comando)"
	exit 1
fi

# se valida que el archivo log sea de texto plano
if ! file --mime-type "$1" | grep -q text/plain$;
then
	echo "El archivo log pasado por parámetro no es de texto plano"
fi

# se valida que el archivo log exista y no esté vacío
if test ! -s "$1"
then
	echo "El archivo log está vacío"
	exit 1
fi

# si se pide generación de archivos reg y reporte por pantalla
if test $2 = "-r" -and $3 = "-p"
then
	# se ejecuta script awk
	awk -f '.\ejercicio4.awk' -v modo="-p" < $1
	exit 1
fi

# si se pide generación de archivos reg sin reporte por pantalla
if test $2 = "-r"
then
	# se ejecuta script awk
	awk -f '.\ejercicio4.awk' -v modo = "-r" < $1
	exit
fi


# se valida que el segundo parámetro no sea -p
if test $2 = "-p"
then
	echo "No se puede ingresar el parámetro -p sin antecederlo por el parámetro -r"
	exit
fi

# si se pide solo el reporte de un legajo por pantalla
if test $2 = "-l"
then
	# se valida que también se ingrese como tercer parámetro el legajo del trabajador
	validate_number=^[0-9]+$;
	if test ! $3 =~ $validate_number
	then
		echo "El legajo del trabajador ingresado es inválido"
		exit
	else
		#se ejecuta script awk
		awk -f '.\ejercicio4.awk' -v modo = "-l" -v empleado = $3 < $1
	fi
fi
