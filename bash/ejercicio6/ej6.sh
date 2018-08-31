#!\bin\bash
# se atiende la solicitud de la ayuda del script
if test $1 = "-?" -o $1 = "-h" -o $1 = "-help"
then
	echo "	
	Sinopsis:

	Nombre del archivo: Ejercicio6.sh
	Trabajo práctico: 2
	Ejercicio: 6
	Autores:
	    - Buzzoni, Ariel - DNI: 41.138.235
	    - Corno, Ezequiel - DNI: 39.430.288
	    - Escobar, Fabián - DNI: 39.210.915
	    - Pereira, Matias - DNI: 37.341.055
	    - Rossi, Alan - DNI: 37.250.221
	Entrega: #1 ENTREGA - 2018/23/05

	Descripcion:

	El script se encargará de mostrar los 10 subdirectorios más grandes de un directorio pasado por
	parámetro. Dichos subdirectorios no deben contener otros directorios dentro, o sea solo los
	directorios hoja en la rama pasada por parámetro. También deberá informar la cantidad de archivos que contienen.
	"

	exit 1
fi

#Valido que haya pasado al menos 1 parámetro
if [ $# == 0 ]; then  
	echo "No se pasaron parámetros"   
	exit 1
fi
#Validación de cantidad de parámetros
if [ $# -gt 2 ]; then  
	echo "LA CANTIDAD DE PARAMETROS ES INCORRECTO"   
	exit 1
fi

#Compruebo que en $1 esté el repositorio a analizar
if ! test $1 = "-?" -o $1 = "-h" -o $1 = "-help"
then
	# lista los 10 subdirectorios de mayor tamaño
	$directorio = du -hs $1 | sort -rh | head -10
	print $directorio

	#recorre los 10 directorios contando la cantidad de archivos que contienen y los muestra por pantalla 
	for $auxdirectorio in $directorio
	 do
		#cantArchivos=$(find . -type f -readable | wc -l)
		$cant = find . -type f -readable| wc -l
		print $auxdirectorio $cant "arch."
	 done
fi
