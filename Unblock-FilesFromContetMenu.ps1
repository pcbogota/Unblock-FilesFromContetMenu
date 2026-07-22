<# Unblock Files
Command for a file
Unblock-File -LiteralPath "C:\ruta\archivo.zip"

command for a folder

Get-ChildItem -LiteralPath "C:\ruta\carpeta" -Recurse -File | Unblock-File

#>

$contenidoRegCommand = @'
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\UnlockZoneIdentifier]
@="Marcar como seguro (Desbloquear)"
"HasLUAShield"=""
;Icono de check en Windows 10/11
"Icon"="shell32.dll,-16810"

[HKEY_CLASSES_ROOT\AllFilesystemObjects\shell\UnlockZoneIdentifier\command]
@="PowerShell -NoProfile -Command \"Start-Process -Verb RunAs -FilePath 'powershell' -ArgumentList '-Command','$ruta = \\\"\\\"\\\"%V\\\"\\\"\\\"; $item = Get-Item -LiteralPath \\\"$ruta\\\"; if ($item.PSIsContainer) { Write-Host \" Desbloqueando la carpeta $ruta... \"; Get-ChildItem -LiteralPath $ruta -Recurse -File | Unblock-File} else { Write-Host \" Desbloqueando el archivo $ruta \"; Unblock-File -LiteralPath $ruta }; Write-Host \"Terminado...\"; Start-Sleep 2'\""
'@

$rutaTemp = "$env:TEMP\debug_ruta_tipo.reg"
$contenidoRegCommand | Out-File -FilePath $rutaTemp -Encoding Unicode -Force

Start-Process -FilePath "regedit.exe" -ArgumentList "/s `"$rutaTemp`"" -Wait

Remove-Item -LiteralPath $rutaTemp -Force

