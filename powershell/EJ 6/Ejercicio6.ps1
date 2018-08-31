<# 
.synopsis
Nombre del archivo: Ejercicio6.ps1
Trabajo práctico: 1
Ejercicio: 6
Autores:
    - Buzzoni, Ariel - DNI: 41.138.235
    - Corno, Ezequiel - DNI: 39.430.288
    - Escobar, Fabián - DNI: 39.210.915
    - Pereira, Matias - DNI: 37.341.055
    - Rossi, Alan - DNI: 37.250.221
Entrega: #1 ENTREGA - 2018/25/04
.description
Recuerda las palabras mostradas desde un archivo que quieras y escribelas una a una
¡Quien más recuerde gana!

.inputs
la ruta del archivo a analizar

.outputs
Guarda los tres mejores puntajes en un archivo .csv

.parameter
Dirección a un archivo de texto con una palabra por línea, al menos 3
Dirección al archivo csv de puntajes
Nombre del jugador

.examples


#>

#Param([Parameter(Mandatory=$true)][String] $path, [Parameter(Mandatory=$true)][String] $scores, [Parameter(Mandatory=$true)][String] $nombre)
Param($path, $scores, $nombre)
Write-Host $path
Write-Host $Scores
Write-Host $Nombre

#Solo para prueba
$path = '.\palabras.txt'
$Scores = '.\puntajes.csv'
$Nombre = 'Pepito'

#TODO: Validar entradas
$palabras = Get-Content -Path $path

#TODO: Verificar if
if($palabras[0] -eq $null){
    Write-Output 'Ingrese un path a un archivo con texto'
    exit
}

$Orden = @() #Almacena el orden de las palabras para repetirlo
$global:gameOver = $false

#Verificar que esté registrado, si no tira error (aunque el código continua)
    Unregister-Event thetimer

$timer = new-object timers.timer

$action = {
    Write-Host "Te quedaste sin tiempo!"
    $global:gameOver = $true
} 

$timer.Interval = 5000 #5 seconds 
$timer.AutoReset = $false
Register-ObjectEvent -InputObject $timer -EventName elapsed –SourceIdentifier thetimer -Action $action

$puntos = -1

while($gameOver -eq $false){
    $Orden += Get-Random -Maximum ($palabras.Count - 1) -Minimum 0 #Agrego el puntero de la primera palabra
    
    Write-Host $palabras[$orden] #Escribo las palabras
    Start-Sleep -S 5 #Da 5 seg para memorizar
    cls
    
    $i = 0
    Write-Host 'Ingrese las palabras de a una por vez en el orden correcto'

    while($gameOver -eq $false -and $i -lt $Orden.Count ){#Mientras que no haya perdido y haya palabras para ingresar
        $timer.Start()

        $palabra = Read-Host
        
        if($palabra -notlike $palabras[$Orden[$i]]){
            Write-Host "La palabra era $($palabras[$Orden[$i]])"
            $gameOver = $true
        }
        
        $timer.Stop()
        
        $i++
    }
    $puntos++
}

Write-host "Perdiste!!!"
#Lee el csv
$csvpuntajes = Import-Csv $scores -Delimiter ','
#Pasa el csv a variables más manejables
$puntajes = @()
foreach($unit in $csvpuntajes){
    $item = New-Object psobject
    $item | Add-Member -MemberType NoteProperty -name "Nombre" -Value $unit.Nombre
    $item | Add-Member -MemberType NoteProperty -Name "Puntaje" -Value ([int]$unit.Puntaje)
    $puntajes += $item
}
#Agrega al jugador en los puntajes
$item = New-Object psobject
$item | Add-Member -MemberType NoteProperty -name "Nombre" -Value $Nombre
$item | Add-Member -MemberType NoteProperty -Name "Puntaje" -Value ([int]$puntos)
$puntajes += $item
#Muestra los 3 mejores
$puntajes |Sort-Object -Property "Puntaje" -Descending|Select-Object -First 3 | Format-Table
#Guarda los puntajes
$puntajes |Sort-Object -Property "Puntaje" -Descending|Select-Object -First 3| Export-Csv -Path $scores -Delimiter ',' -Encoding UTF8

#TODO Completar la descripción del script
#TODO arreglar función Get-Help, no se muestra.

<#
    NOTAS
    Cuando ejecuta en el ISE no hay nigún problema,
    en la consola si ingresas una palabra tarde muestra el
    "te quedaste sin tiempo" pero espera a que termines de
    ingresar las palabras antes de pasar al mensaje "Perdiste"
    Si se le agrega el TAG $global: a todos los $gameOver no 
    funciona, ni en el ISE ni la consola si se deja el tag en
    los casos donde se modifica gameOver entonces funciona solo
    en el ISE
#>

Unregister-Event thetimer