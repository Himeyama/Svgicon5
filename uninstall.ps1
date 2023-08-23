$bin = "$env:USERPROFILE\AppData\Local"
$appName = "Svg2Ico"

# Stop process if running a app
Get-Process -Name $rawAppName -ErrorAction SilentlyContinue
if($?){
    Stop-Process -Name $rawAppName
}
Start-Sleep -Milliseconds 500

# Remove if a app directory exist
$installDir = "$bin\$appName"
if(Test-Path -Path $installDir){
    Remove-Item -Path $installDir -Recurse -Force
}

# Remove a shortcut in desktop
$desktop = [System.Environment]::GetFolderPath("Desktop")
$shortcutPath = "$desktop\Svgicon5.lnk"
if(Test-Path -Path $shortcutPath){
    Remove-Item -Path $shortcutPath -Force
}
