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

function Create-Shortcut($target, $linkName){
    $WshShell = New-Object -ComObject WScript.Shell
    $desktop = [System.Environment]::GetFolderPath("Desktop")
    $Shortcut = $WshShell.CreateShortcut("$desktop\$linkName")
    $Shortcut.TargetPath = $target
    $Shortcut.Save()
}

Remove "$env:LOCALAPPDATA\SVG2ICO" "SVG2ICO"
Copy-Item -Recurse win10-x64 "$env:LOCALAPPDATA\SVG2ICO"
Create-Shortcut "$env:LOCALAPPDATA\SVG2ICO\SVG2ICO.exe" "SVG2ICO.lnk"
