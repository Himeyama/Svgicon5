function Stop-App($appName){
    Get-Process -Name $appName -ErrorAction SilentlyContinue
    if ($?) {
        Stop-Process -Name $appName
    }
    Start-Sleep -Milliseconds 500
}

function Remove($files, $appName) {
    Stop-App $appName
    if (Test-Path $files) {
        Remove-Item -Recurse -Force $files
    }
}

Remove "$env:LOCALAPPDATA\SVG2ICO" "SVG2ICO"
$desktop = [System.Environment]::GetFolderPath("Desktop")
Remove "$desktop\SVG2ICO.lnk" "SVG2ICO"
