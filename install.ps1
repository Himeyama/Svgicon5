$bin = "$env:USERPROFILE\AppData\Local"
$appName = "Svg2Ico"
$rawAppName = "Svgicon5"

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

# Remove build a directory
Remove-Item -Recurse -Force .\Svgicon5\bin

# Build on Release mode and based on Svgicon5.csproj
dotnet build Svgicon5\Svgicon5.csproj -c Release -r win10-x64

# Copy a app directory
$buildDst = ".\Svgicon5\bin\x64\Release"
$releaseDir = (Get-ChildItem $buildDst)[0].Name
Copy-Item -Recurse "$buildDst\$releaseDir\win10-x64" $installDir

# Create a shortcut in desktop
$WshShell = New-Object -ComObject WScript.Shell
$desktop = [System.Environment]::GetFolderPath("Desktop")
$Shortcut = $WshShell.CreateShortcut("$desktop\SVG2ICO.lnk")
$Shortcut.TargetPath = "$env:USERPROFILE\AppData\Local\Svg2Ico\SVG2ICO.exe"
$Shortcut.Save()

