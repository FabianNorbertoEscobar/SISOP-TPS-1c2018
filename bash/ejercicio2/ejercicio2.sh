#!/bin/bash
#***********************************************************************************
# Nombre Del Script:        ejercicio2.sh
# Trabajo Practico Nro.:    2
# Ejercicio Nro.:           1
# Entrega Nro.:             1
# Integrantes:
#
#	Apellidos	    	Nombres		          DNI
#	--------------------------------------------
#	
#   Barja Fernandez 	Omar Max			36241378
#	Rojas Stoll   		Hector Carlos		94448064
#   Feito,           	Gustavo				27027190
#	Miranda       		Sergio Javier		35634266
#	
#
#***********************************************************************************

function ayuda()
{
  echo "*************************************"
  echo "*AYUDA PARA LA EJECUCION DEL SCRIPT *"
  echo "*************************************"

  echo "OPCIONES POSIBLES:"
  echo "     "$0"  <ruta/archivo> <ruta/archivo>"
}

##########################################
########## menu ayuda #########
##########################################
if test "$1" = "-h" -o "$1" = "-?" -o "$1" = "-help"
then
  ayuda
  exit 0
fi
#Validar la cantidad de parametros
if [ $# != 2 ]; then
echo "ERROR: cantidad de parametros incorrectos"
echo "Consultar la ayuda:"
echo "     "$0" -h"
exit 1
fi
#Validar si los parametros ingresados son archivos
if ! [ -f "$1" ]; then
echo "ERROR: el primer parametro no es un archivo correcto"
echo "Consultar la ayuda:"
echo "     "$0" -h"
exit 2
fi
if ! [ -f "$2" ]; then
echo "ERROR: el segundo parametro no es un archivo correcto"
echo "Consultar la ayuda:"
echo "     "$0" -h"
exit 3
fi
# paso a hacer el tartamiento del archivo
file -i "$1" | grep text/plain >> /dev/null
if [ $? != 0 ]
then
echo "ERROR: en el contenido del archivo "
echo "Consultar la ayuda:"
echo "     "$0" -h"
exit 4
fi
cp $1 $1.bak#realizo backup del archivo original
ARCH1=/tmp/`basename $1`.$$
sed 's/[A-Z]*/\L&/g' $1 > $ARCH1
sed -i 's/, /, ^./^['$2']/\u&/' $ARCH1
mv $ARCH1 $1
#finScript
