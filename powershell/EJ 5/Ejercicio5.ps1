Param([Parameter(Mandatory=$true)][string]$path_procesos, [Parameter(Mandatory=$false)][switch]$K,
                                                          [Parameter(Mandatory=$false)][switch]$C,
                                                          [Parameter(Mandatory=$false)][switch]$U)


<#$path_procesos = "F:\EZEQUIEL\Sistemas Operativos\SISOP\EJ 5\Procesos.txt"
$parametro = "-U"
#>




if(!(Test-Path Errores.log))
{
    new-item -itemtype "File" "$(Split-Path -Path $path_procesos)\Errores.log"
}



$archivo = Get-Content $path_procesos 

$palabras = $archivo.Trim()

if($U.IsPresent){
                  foreach($palabra in $palabras){
                     $procesos = Get-WmiObject -Class Win32_Process | Where-Object -Property ProcessName -eq $palabra | Select-Object -Property ProcessName
                     $flag = $false
                     foreach($proceso in $procesos){
                       if($proceso.ProcessName -eq $palabra){
                          $processid = Get-Process | Where-Object -Property ProcessName -eq ([io.path]::GetFileNameWithoutExtension($palabra)) | Select-Object -Property Id
                            
                          echo ""

                          echo "El Proceso $palabra :"

                          echo "TIene como PID: $($processid.Id)"
                            
                          $memoria = Get-WmiObject -Class Win32_Process | Where-Object -Property ProcessName -eq $palabra | Select-Object -Property PrivatePageCount 
                
                          $memoria = $memoria.PrivatePageCount/1024/1024
               
                          echo "$($memoria |%{$_.toString("#.##")}) MB usadas de Memoria"
                
                          $cpu = Get-Counter "\proceso($([io.path]::GetFileNameWithoutExtension($palabra))*)\% de tiempo de procesador"
                
                          echo "Porcentaje de Uso de CPU: $($cpu.CounterSamples[0].CookedValue)"

                          Get-Counter "\proceso($palabra*)\% de tiempo de procesador" | % {$_.countersamples.cookedvalue}

                          $flag=$true
                                }
                            }
                    if($flag -eq $false){
                        Write-Log -msj "[ERROR]-{El Proceso $($palabra) no se encuentra en ejecucion} $(get-date -Format hh:mm:ss)" 
                    }
                }
               exit  
              }
                

if($C.IsPresent){
                 foreach($palabra in $palabras){
                    $procesos = Get-WmiObject -Class Win32_Process | Where-Object -Property ProcessName -eq $palabra | Select-Object -Property ProcessName
                    $flag = $false
                    foreach($proceso in $procesos){
                        if($proceso.ProcessName -eq $palabra){
                            $processid = Get-Process | Where-Object -Property ProcessName -eq ([io.path]::GetFileNameWithoutExtension($palabra)) | Select-Object -Property Id
                            
                            echo ""

                            echo "El Proceso $palabra :"

                            echo "TIene como PID: $($processid.Id)"
                            
                            $cpu = Get-Counter "\proceso($([io.path]::GetFileNameWithoutExtension($palabra))*)\% de tiempo de procesador"
                
                            echo "Porcentaje de Uso de CPU: $($cpu.CounterSamples[0].CookedValue)"

                            Get-Counter "\proceso($palabra*)\% de tiempo de procesador" | % {$_.countersamples.cookedvalue}
                          
                            $flag=$true
                        }
                    }
                    if($flag -eq $false){
                        Write-Log -msj "[ERROR]-{El Proceso $($palabra) no se encuentra en ejecucion} $(get-date -Format hh:mm:ss)" 
                    }
                } 
            exit
            }

if($K.IsPresent){
                 foreach($palabra in $palabras){
                 $procesos = Get-WmiObject -Class Win32_Process | Where-Object -Property ProcessName -eq $palabra | Select-Object -Property ProcessName
                 $flag = $false
                 foreach($proceso in $procesos){
                 if($proceso.ProcessName -eq $palabra){
                    kill -name ([io.path]::GetFileNameWithoutExtension($proceso.ProcessName)) -Force
                    $flag=$true
                }
            }
            if($flag -eq $false){
                Write-Log -msj "[ERROR]-{El Proceso $($palabra) no se encuentra en ejecucion} $(get-date -Format hh:mm:ss)" 
            }
                 
        }
        exit
}


Function Write-Log
{  [CmdLetBinding()]
   Param([string]$msj)

   Add-content "Errores.log" -value $msj
}