<# 

.SYNOPSIS
Nombre del archivo: Ejercicio4.ps1
Trabajo práctico: 1
Ejercicio: 4
Autores:
    - Buzzoni, Ariel - DNI: 41.138.235
    - Corno, Ezequiel - DNI: 39.430.288
    - Escobar, Fabián - DNI: 39.210.915
    - Pereira, Matias - DNI: 37.341.055
    - Rossi, Alan - DNI: 37.250.221
Entrega: #2 ENTREGA - 2018/02/05

.DESCRIPTION
Stocks y precios

.INPUTS
La carpeta donde se encuentran los archivos de los proveedores, la dirección del archivo inventario y opción de backup

.OUTPUTS
Guarda el inventario editado y el backup corresponde

.PARAMETER inventario
Dirección al archivo inventario

.PARAMETER proveedor
Dirección de la carpeta proveedores

.PARAMETER backup
Realiza un backup



#>


param( [ parameter(mandatory=$true)][string]$inventario,
       [parameter(mandatory=$true)][string]$proveedor,
       [parameter(mandatory=$false)][switch]$backup )




if($backup){
    Copy-Item -Path $inventario -Destination $inventario.TrimEnd("4") -Recurse -PassThru
}


[xml]$inv = Get-Content $inventario

cd $proveedor

$prov = Get-ChildItem

foreach($archivo in $prov){
   if ($archivo.FullName -match 'precio'){
       [xml]$arch_Pre= Get-Content $archivo
       foreach($articulo in $arch_Pre.precios.producto){
          foreach($producto in $inv.inventario.producto){
              if($producto.codigo -eq $articulo.codigo){
                 if($articulo.precio.porcentaje -eq $true){
                    $producto.precio=[string]([int]$producto.precio + ([int]$producto.precio * [int]$articulo.precio.'#text')/100)
                    }else{
                       $producto.precio=[string]([int]$producto.precio + [int]$articulo.precio.'#text')
                    }
                    $inv.Save($inventario) 
                    break

                  }

                }
            }
            foreach($articulo in $arch_Pre.precios.producto){
                $existe = $false
                foreach($prod in $inv.inventario.producto){
                    if($articulo.codigo -eq $prod.codigo){
                        $existe = $true
                    }
                }
                if(!$existe){
                    $aux=$inv.CreateElement("producto")
                    $aux.SetAttribute("codigo",$articulo.codigo)
                    $aux.SetAttribute("descripcion",$articulo.descripcion)
                    $aux.SetAttribute("codigoProveedor",$archivo.Name.Split("_")[0])
                    $aux.SetAttribute("precio",$articulo.precio)
                    $aux.SetAttribute("stock","0")
                    $inv.inventario.AppendChild($aux)
                    $inv.Save($inventario) 
                }
            }

        }else{
        
        [xml]$archStock= Get-Content $archivo
        foreach($articulo in $archStock.stock.producto){
           foreach($producto in $inv.inventario.producto){
             if($producto.codigo -eq $articulo.codigo){
                $producto.stock = [string]([int]$producto.stock + [int]$articulo.stock)
                }
            $inv.Save($inventario) 
            }
        }
    }
}