<# 
.synopsis
Nombre del archivo: Ejercicio1.ps1
Trabajo práctico: 1
Ejercicio: 1
Autores:
    - Buzzoni, Ariel - DNI: 41.138.235
    - Corno, Ezequiel - DNI: 39.430.288
    - Escobar, Fabián - DNI: 39.210.915
    - Pereira, Matias - DNI: 37.341.055
    - Rossi, Alan - DNI: 37.250.221
Entrega: #1 ENTREGA - 2018/25/04
.description

Responda:
a. ¿Cuál es el objetivo del script? No explicar paso a paso, sino el objetivo.
b. ¿Qué validaciones serían útiles agregar al parámetro $path?
c. ¿Para qué sirve el operador -match?
d. ¿Cómo reemplazaría el bucle foreach por una concatenación de cmdlets?

Respuestas:
a. El objetivo del script es contar la cantidad de archivos que hay una ruta que contengan en su nombre numeros de 0 a 9 y mostrarla.

b.   
   Corrección:
   Param
    (
        [Parameter(Mandatory=$True,Position=1, HelpMessage="Ingrese un path"] [ValidateNotNullOrEmpty()][string]$path
    )
    Dado a la posibilidad de que el parámetro no fue definido como mandatario, y el mismo es esencial en la lógica del script: lo hacemos mandatorio, validamos que no sea null o vacio y además que tire un mensaje de ayuda "Ingrese un path".

c. El operador busca una cadena usando expresiones regulares. Cuando la entrada es escalar, rellena la variable automática $Matches.

d. reemplazamos el for each por un where-object donde tiene como flujo de entrada la salida del get-childitem, filtramos por la condicion necesaria y luego utlizamos el atributo count de la collection. El resultado lo guardamos en una variable "contador" y lo mostramos.
.notes

EL CÓDIGO REEMPLAZANDO EL FOR EACH:

Param($path)
$contador=0 
$contador = (Get-ChildItem $path -File -Recurse | 
Where-Object {$_.FullName -match ‘[0-9]’}).count
echo $contador

.inputs
la ruta del archivo a analizar

.outputs
el script muestra la cantidad de archivos encontrados.

.parameter
un path donde buscar archivos con numeros de 0 a 9 en el nombre.

.examples
./Ejercicio 1.ps1 F:\EZEQUIEL\Sistemas Operativos\Trabajo Practico 1 - Escobar, Corno, Pereira, Buzzoni, Rossi\EJ 1

#>

Param($path)
$contador=0 
$a = Get-ChildItem $path -File -Recurse
foreach ($item in $a) {
if ($item.FullName -match ‘[0-9]’) {
$contador++
}
}
Write-Output $contador


