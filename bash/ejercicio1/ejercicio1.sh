#!/bin/bash

if [ $# != 1 ];

echo "Parametro no ingresado"

exit

fi

if ! [ -f "$1" ]; then

echo "Archivo no valido o inexistente"

exit

fi

file -i "$1" | grep text/plain >> /dev/null

if [ $? != 0 ]

then

echo "El archivo ingresado no es de texto"

exit

fi

cp $1 $1.bak 

ARCH1=/tmp/`basename $1`.$$ 

sed 's/[A-Z]*/\L&/g' $1 > $ARCH1 

sed -i 's/^./\u&/' $ARCH1 

mv $ARCH1 $1


#1) El comando #!/bin/bash se utiliza para indicar con que shell se debe ejecutar el script, en caso de no especificarlo se utiliza el shell por default.

#2) Podemos otorgar los permisos de ejecucion a través del comando chmod cuando ejecutamos el script escribiendo: chmod u=555 script.sh asi otorgamos el permiso de lectura y ejecucion

#3) $1 es el parámetro que se encuentra en la posición 1. Van del $1...$9. $# es el número de parámetros. $? Contiene el estado de terminación de un comando, si es 0 significa que el estado fue satisfactorio. Además tenemos la variable $0 que específica  el nombre del script y $* que contiene todos los argumentos.

#4) Recibe un texto plano, hace un backup y hace una modificacion en su contenido en un archivo temporal y le asigna el nombre original del archivo pasado por parametro

#6)  Sed permite modificar el contenido de las diferentes líneas de un archivo en base a una serie de comandos,  con -i se inserta una linea antes de la linea actual, -a se inserta una línea después de la línea actual, -p imprime la línea actual, -s  sustituye una cadena por otra en cada línea de la entrada

#7) Da error porque es un caracter especial y cree que el Path finalizó despues del espacio. Lo solucionaría ingresando el path entre comillas para que tome el valor literal de la cadena.


