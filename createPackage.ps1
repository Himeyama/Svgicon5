function Remove($files){
    if(Test-Path $files){
        Remove-Item -Recurse -Force $files
    }
}

Remove .\Svgicon5\bin

