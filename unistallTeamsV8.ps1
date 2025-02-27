<#
#*******Begin Comment**************
.SYNOPSIS
#	This script performs the  uninstallation of an application(s).
#  Script for Ünistall MS TEAMS Clasic 
# version MS TEAMS  1.6.0.1381
# Autor: Saith Barreto
# Fecha: Septiembre 2024
#*******End Comment**************
# Import internal organization-specific modules, packages, and libraries if needed
#>
# Define the log path where the log file will be saved
[string]$logPath = "C:\Windows\logs\uninstallTeams.log"

# Function to write log messages to the log file
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "$timestamp - $message"
}

#Obtener la lista de perfiles de usuario en la máquina
$profiles = Get-ChildItem -Path "C:\Users" -Directory

foreach ($profile in $profiles) {
    $updatePath = Join-Path -Path $profile.FullName -ChildPath "AppData\Local\Microsoft\Teams\Update.exe"
    # Define the registry path to check for Microsoft Teams installation
    #If (((Test-Path "HKLM:\SOFTWARE\AXA\Applications\TeamsX64_1.6_Multi_V01") -or (Test-Path "C:\Program Files\Microsoft\Teams") -or (Test-Path $updatePath)  ) -eq $true) {
    # Comando para desinstalar Microsoft Teams
    #Write-Log "Microsoft Teams versión  está instalado. Procediendo a desinstalar"
    Start-Process "msiexec.exe" -ArgumentList "/x {731F6BAA-A986-45A4-8936-7C3AAAAA760B} /quiet" -Wait
    # Obtener todos los usuarios en el dispositivo
    $TeamsUsers = Get-ChildItem -Path "$($ENV:SystemDrive)\Users"
    # Recorrer cada usuario y eliminar la aplicación Teams. ¡Esto se ejecuta en el contexto del SISTEMA! También deberá ignorar el código de salida -1.
    $TeamsUsers | ForEach-Object {
        Try { 
            "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams\Update.exe --uninstall -s" 
        }
        Catch { 
            Out-Null
        }
    }
    # Eliminar los datos de la aplicación para $($_.Name).
    $TeamsUsers | ForEach-Object {
        Try {
            Remove-Item -Path "$($ENV:SystemDrive)\Users\$($_.Name)\AppData\Local\Microsoft\Teams" -Recurse -Force -ErrorAction Ignore
            Write-Log "Microsoft Teams Users ha sido desinstalado"
        }
        Catch {
            Out-Null
        }
    }
    
    Write-Log "Microsoft Teams ha sido desinstalado."
    Exit 0
}
    
#}
Write-Log "Microsoft Teams Users NO EXISTE EN EL EQUIPO"
Exit 0