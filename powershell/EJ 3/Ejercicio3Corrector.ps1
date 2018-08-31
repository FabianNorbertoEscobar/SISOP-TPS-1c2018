<# 

.SYNOPSIS
Nombre del script: Ejercicio3Corrector.ps1
Trabajo Práctico: 1
Ejercicio: 3

Grupo:
    - Buzzoni, Ariel - DNI: 41.138.235
    - Corno, Ezequiel - DNI: 39.430.288
    - Escobar, Fabián - DNI: 39.210.915
    - Pereira, Matias - DNI: 37.341.055
    - Rossi, Alan - DNI: 37.250.221


Sistemas Operativos
Comisión= 1333
Entrega: #1 ENTREGA - 25/04/2018

Objetivo del script: corrección de mayúsculas iniciales de cada oración en archivos de texto.

.DESCRIPTION
El script cambia a mayúscula la primera letra de cada oración de un archivo de texto.
Se entiende por oración a una cadena de caracteres separada por un punto.

En la misma ruta del archivo a modificar, se coloca el archivo corregido, con el agregado _modif al nombre.
Se registran las modificaciones en un archivo de log.

.PARAMETER rutaArchivo
El path del archivo de texto a corregir

.PARAMETER rutaLog
El path del archivo de log donde se registrarán las modificaciones

.EXAMPLES
./Ejercicio3Corrector.ps1 -rutaArchivo ./prueba.txt -rutaLog ./log.log

.INPUTS
Ruta del archivo a corregir
Ruta del log

.OUTPUTS
Archivo corregido en la ruta del original
Archivo de log en la ruta de log

.NOTES
Si el archivo de log no existe, se crea uno nuevo.
Si ya existe, se anexan los nuevos reportes de errrores al final.
Utilizado por el script del archivo ejercicio3Lanzador.ps1, que se encuentra en la misma ruta.

#>


#se validan los parámetros
Param (
    [Parameter(Mandatory=$True, Position=1, HelpMessage="Ingrese el path del archivo a corregir:")]
    [ValidateNotNullOrEmpty()][string]$rutaArchivo,
    
    [Parameter(Mandatory=$True, Position=2, HelpMessage="Ingrese el path del log:")]
    [ValidateNotNullOrEmpty()][string]$rutaLog
)


#si se reciben rutas relativas, se obtienen las rutas absolutas
if(-not ($rutaArchivo.Contains(':\'))) {
    $rutaArchivo = $rutaArchivo.Replace('.\','')
    $rutaArchivo = "$(Get-Location)\$rutaArchivo"
}
if(-not ($rutaLog.Contains(':\'))) {
    $rutaLog = $rutaLog.Replace('.\','')
    $rutaLog = "$(Get-Location)\$rutaLog"
}


#se arma el path del archivo modificado
$modificado = ($rutaArchivo.TrimEnd(".txt") + "_modif.txt")

#si el archivo corregido existe, se elimina
if(Test-Path $modificado) {
    Remove-Item -Path $modificado    
}

#se crea el archivo corregido
New-Item -Path $modificado -ItemType File


#se abre el archivo de texto
$archivo = Get-Content  $rutaArchivo

#se comienza a contar la cantidad de modificaciones
$modificaciones = 0

#se parte en párrafos
$parrafos = $archivo.Split("`n")

#para cada párrafo
foreach($parrafo in $parrafos) {
    
    #se inicializa el texto corregido
    $corregido = ""

    #si el párrafo no está vacío
    if(-not [string]::IsNullOrWhiteSpace($parrafo)) {
        
        #se parte en oraciones
        $oraciones = $parrafo.TrimEnd(".").Split(".").Trim()

        #para cada oración
        foreach($oracion in $oraciones) {

            #si la oración no está vacía
            if(-not [string]::IsNullOrWhiteSpace($oracion)) {

                #se parte en palabras
                $palabras = $oracion.Split(" ")

                #se pone en mayúscula la primera letra de la primera palabra
                $palabras[0] = (Get-Culture).TextInfo.ToTitleCase($palabras[0])
    
                #se cuenta la modificación
                $modificaciones++
    
                #se agrega la primera palabra al texto corregido
                $corregido += $palabras[0]

                #se agrega el resto de las palabras
                $i = 1
                while($palabras[$i]) {
                    $corregido += " " + $palabras[$i]
                    $i++
                }

            }

            #se agrega el punto
            $corregido += ". "
    
        }

    }

    #se agrega el texto corregido al archivo
    Add-Content -Path $modificado -Value $corregido
}


#se arma la fecha y se obtiene el nombre del archivo
$fecha = (Get-Date -Format dd/MM/yyyy)
$fileName = (Split-Path $rutaArchivo -Leaf)

#se reporta en el log
$reporte = "[Modificaciones: $modificaciones - Archivo: $fileName - Fecha: $fecha]"
$reporte >> "$rutaLog"
