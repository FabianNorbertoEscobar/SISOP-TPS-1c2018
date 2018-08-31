#!/usr/bin/awk -f
BEGIN{
	# se reemplazan los separadores
	FS=";"
	ORS_OLD=ORS
	OFS_OLD=OFS
	ORS="\n"
	OFS=";"

	# se arma la fecha en formato año/mes
	str="date +%m%Y";
	str|getline date;
	close(str);

	# se arma la fecha en formato mes/año
	str="date +%m/%Y";
	str|getline date2;
	close(str);

}
# se matchea con regex para saltear el encabezado
$1 ~ /^[0-9]+$/ {

	# se genera el nombre del archivo reg
	archivo = $1 "_" date ".reg"

	# se arma el campo fecha
	$2 = $2 "/" date2
	
	# se calculan las horas trabajadas 
	split($3,a,":")
	split($4,b,":")

	aMinutos = a[1]*60 + a[2]
	bMinutos = b[1]*60 + b[2]
	
	restaMinutos = bMinutos - aMinutos
	horasTrabajadas = int(restaMinutos / 60)
	minutosTrabajados = restaMinutos % 60
	

	hhmm = horasTrabajadas ":" minutosTrabajados

	minutostotales = horasTrabajadas*60 + minutosTrabajados


	minutos[$1] = minutos[$1] + minutostotales
	# se escribe el registro en el archivo reg
	print $0,hhmm >> archivo
	close(archivo)
}
END{
	# si se pide la generación de archivos reg
	if ( modo = "-r" )
	then	
		# se reemplazan los separadores
		ORS=ORS_OLD
		OFS=OFS_OLD

		# se agrega resumen de horas a cada archivo
		 
		i=1
		for(legajo in minutos){
			archivo=legajo "_" date ".reg"
			print "......................................" >> archivo
			print "Total de horas teóricas: 176:00" >> archivo
			horastotales = int(minutos[legajo] / 60)
			minutototal = minutos[legajo] % 60

			if ( minutototal < 10 ){
				minutototal = "0" minutototal
			}

			print "Total de horas trabajadas: " horastotales ":" minutototal >> archivo
			
			h_teoricas = 176
			h_extras = horastotales - h_teoricas
			
			if ( h_extras > 0 ){
				print "Horas Extras: " h_extras ":00" >> archivo
			}
			else{
				print "Horas Extras: 00:00" >> archivo
			}
			i++
		}	
	fi

	# si se pide el reporte por pantalla
	if ( modo = "-p" )
	then
		# se muestran las horas trabajadas
		print "Cantidad de legajos procesados: " i
		for(legajo in minutos){
			horastotales = int(minutos[legajo] / 60)
			minutototal = minutos[legajo] % 60
			print "Legajo: " legajo " Total de horas trabajadas: " horastotales ":" minutototal
		}
	fi

	# si se pide solo el reporte de un legajo por pantalla
	if ( modo = "-l" )
	then
		# se muestra por pantalla el resumen de horas para el legajo pedido
		for(legajo in minutos){
			if(legajo -eq empleado)
			print "Legajo: " empleado
			print "Total de horas teóricas: 176:00"
			horastotales = int(minutos[legajo] / 60)
			minutototal = minutos[legajo] % 60
			print "Total de horas trabajadas: " horastotales ":" minutototal 
			
			h_teoricas = 176
			h_extras = horastotales - h_teoricas
			
			if ( h_extras > 0 ){	                            
				print "Horas Extras: " h_extras ":00" 
			}
			else{
				print "Horas Extras: 00:00"
			}
		}
	fi
}
