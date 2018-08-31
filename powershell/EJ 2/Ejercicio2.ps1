
Param([Parameter(Mandatory=$true)][string]$path_dir)

$prepo = 'a','ante','bajo','cabe','con','contra','de','desde','durante','en','entre','hacia','hasta','mediante','para','por','sin','so','sobre','tras','versus','vía'


cd $path_dir
$CantPag = 0
$contenido = gci 
$cantpal = @{}
foreach ($item in $contenido){
$html = Get-Content $item -Raw
$doc = New-Object -com "HTMLFILE"
$doc.IHTMLDocument2_write($html)


$palabras = $doc.title.Split(' ')
$i = 0
while($i -lt $palabras.count){
    if(!$prepo.Contains($palabras[$i])){
        #si esta sumar
        if($cantpal.ContainsKey($palabras[$i])){
            $cantpal[$palabras[$i]]+=1
        }else{
            #Si no está, agregar
            $cantpal.add($palabras[$i], 1)
        }
    }
    $i++
}
$CantPag++
}


echo "Páginas Analizadas:` $CantPag"
echo 'Resultados Obtenidos:'

$tabla = $cantpal.GetEnumerator() | sort value -Descending | Select-Object -First 5 

$tabla_ord = @()

For($i = 0; $i -le 4; $i++) {  

        #creo un nuevo objeto de Powershell
        $obj = New-Object PSObject

        #coloco los atributos que necesito
    
        $obj | Add-Member -MemberType NoteProperty -name "# " -value $($i + 1)

        $obj | Add-Member -MemberType NoteProperty -name "Palabra" -value $($tabla[$i].Key)

        $obj | Add-Member -MemberType NoteProperty -name "Cantidad de Ocurrencias" -value $($tabla[$i].Value)
        #agrego el objeto al array
        $tabla_ord += $obj
    }
echo $tabla_ord

