<# 

.SYNOPSIS
Nombre del script: Ejercicio3Lanzador.ps1
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

Objetivo del script: corrección de mayúsculas iniciales de cada oración en archivos de texto al cerrarse un editor de texto

.DESCRIPTION
Ejecuta un script que cambia a mayúscula la primera letra de cada oración de un archivo de texto.
Se entiende por oración a una cadena de caracteres separada por un punto.

Un job en segundo plano ejecuta el script que realiza las correcciones cada vez que el archivo es modificado.

En la misma ruta del archivo a modificar, se coloca el archivo corregido, con el agregado _modif al nombre.
Se registran las modificaciones en un archivo de log.

.PARAMETER rutaArchivo
El path del archivo de texto a corregir

.PARAMETER rutaLog
El path del archivo de log donde se registrarán las modificaciones

.PARAMETER editor
El nombre del editor de texto

.EXAMPLES
./Ejercicio3Lanzador.ps1 -rutaArchivo ./prueba.txt -rutaLog ./log.log -editor notepad.exe

.INPUTS
Ruta del archivo a corregir
Ruta del log
Nombre del editor de texto

.OUTPUTS
Archivo corregido en la ruta del original
Archivo de log en la ruta de log

.NOTES
Si el archivo de log no existe, se crea uno nuevo.
Si ya existe, se anexan los nuevos reportes de errrores al final.
Utiliza el script del archivo ejercicio3Corrector.ps1, que se encuentra en la misma ruta.

#>


#se validan los parámetros
Param (
    [Parameter(Mandatory=$True, Position=1, HelpMessage="Ingrese el path del archivo a corregir:")]
    [ValidateNotNullOrEmpty()][string]$rutaArchivo,
    
    [Parameter(Mandatory=$True, Position=2, HelpMessage="Ingrese el path del log:")]
    [ValidateNotNullOrEmpty()][string]$rutaLog,

    [Parameter(Mandatory=$True, Position=3, HelpMessage="Ingrese el nombre del editor de texto:")]
    [ValidateNotNullOrEmpty()][string]$editor
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

#se corta la extensión del editor
$editor = $editor.TrimEnd(".exe")


#se monitorea la actividad del editor de texto
while($true){
    
    #se cicla mientras el editor está cerrado
    while( (Get-Process -Name $editor -ErrorAction SilentlyContinue) -eq $null) {
    
    }
    
    #se cicla mientras el editor está abierto
    while( Get-Process -Name $editor -ErrorAction SilentlyContinue) {
    
    }
    
    #se lanza un job que ejecuta el script corrector en segundo plano al cerrarse el editor
    Start-Job -FilePath "$(Get-Location)\Ejercicio3Corrector.ps1" -ArgumentList $rutaArchivo, $rutaLog
}
