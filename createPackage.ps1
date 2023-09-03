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

function Build($projectFile, $appName) {
    Stop-App $appName
    dotnet publish $projectFile -c Release -r win10-x64
}

function Compress-Package($binDir){
    $subDir = (Get-ChildItem "$binDir\x64\Release")[0].Name
    $target = "$binDir\x64\Release\$subDir\win10-x64"
    Compress-Archive -Path $target,AppConfig.json,README.md,inst.ps1,uninst.ps1,PotableInstaller.lnk -DestinationPath "SVG2ICO.zip" -Force
}

Remove "Svgicon5\bin" "SVG2ICO"
Build "Svgicon5\Svgicon5.csproj" "SVG2ICO"
Compress-Package "Svgicon5\bin"
