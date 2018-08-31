#!bin/bash

function ayuda() {
	echo "NAME"
	echo "script3.sh"
	echo " "
	echo "SYNOPSIS"
	echo "./script3.sh /path/ArchivoA /path/ArchivoB -i"
	echo " "
	echo "DESCRIPTION"
	echo "El script se encarga de buscar ArchivoA con una lista de palabras separadas por saltos de líneas, encuentre "
	echo "Deberá mostrar por pantalla la cantidad de coincidencias de cada palabra y la cantidad de palabras de B que "
	echo "no aparecen en el archivo A."
	echo "Adicionalmente, se permitirá mandar un tercer parámetro ( –i ) para indicar que la búsqueda no diferenciará entre minúsculas y mayúscula."
	echo "En caso de que este último parámetro se omita, la búsqueda deberá ser case sensitive."
	echo " "
	echo " -?, -h, -help	Accede a la ayuda del script"
}

if [ $# == 0 ]; then  
	echo "EL NUMERO DE PARAMETROS ES INCORRECTO"   
	exit 
fi

if [ $# == 1 ]; then
	MODIFICADOR="$1"
	if [ "$MODIFICADOR" == "-?" ];then
		ayuda
		exit
	fi

	if [ "$MODIFICADOR" == "-h" ];then
		ayuda
		exit
	fi

	if [ "$MODIFICADOR" == "-help" ];then
		ayuda
		exit
	fi
	echo "EL NUMERO DE PARAMETROS ES INCORRECTO"   
	exit
fi

ARCHIVOA="$1"
ARCHIVOB="$2"
INDICADOR="$3"

archA=$(cat $ARCHIVOA)
archB=$(cat $ARCHIVOB)

declare -A hashA
declare -A hashB
declare -A hashRA

if [ $# == 3 ]; then
	if [ -f $ARCHIVOA ];then
		if [ -f $ARCHIVOB ];then
			if [ "$INDICADOR" == "-i" ];then				
				#Carga de hash
				for palabraA in $archA
				do
					#Para que no distinga minusculas y mayusculas, paso todo a minusculas
					palabraA=${palabraA,,}
					hashA[$palabraA]=1	
				done

				for palabraB in $archB
				do
					#Para que no distinga minusculas y mayusculas, paso todo a minusculas
					palabraB=${palabraB,,}
					let hashB[$palabraB]++
				done


				#Recorro hashA para comparar contra hashB
				for iA in ${!hashA[*]}
				do  
					for iB in ${!hashB[*]}
					do 						
						if [ $iA == $iB ];then
							hashRA[$iA]=${hashB["$iB"]}
						fi
					done
				done

				#Recorro hashB para comparar contra hashA
				acumulador=0
				flag=0
				for iB in ${!hashB[*]}
				do  				
					for iA in ${!hashA[*]}
					do						
						if [ $iB != $iA ];then
							flag=1
						else
							flag=0
							break
						fi
					done
					if [ $flag == 1 ];then						
						let acumulador++
					fi
					flag=0
				done

				#Muestro por pantalla
				for pala in ${!hashRA[*]}
				do
					echo -e "$pala : ${hashRA["$pala"]} \n"
				done

				echo "No se encuentran en A: $acumulador"
			else
				echo "Indicador incorrecto, solo se permite -i"
				exit
			fi
		fi
	fi
fi

if [ $# == 2 ];then
	if [ -f $ARCHIVOA ];then
		if [ -f $ARCHIVOB ];then
			#Carga de hash
			for palabraA in $archA
			do
				hashA[$palabraA]=1
			done

			for palabraB in $archB
			do
				let hashB[$palabraB]++
			done

			#Recorro hashA para comparar contra hashB
			for iA in ${!hashA[*]}
			do  
				for iB in ${!hashB[*]}
				do
					if [ $iA==$iB ];then
						let hashRA["$iB"]++
					fi
				done
			done

			#Recorro hashB para comparar contra hashA
			acumulador=0
			for iB in ${!hashB[*]}
			do  				
				for iA in ${!hashA[*]}
				do						
					if [ $iB != $iA ];then
						flag=1
					else
						flag=0
						break
					fi
				done
				if [ $flag == 1 ];then						
					let acumulador++
				fi
				flag=0
			done

			echo "No se encuentran en A: $acumulador"
		fi
	fi
fi
