# プロジェクトファイルのパス
$csproj = ".\Svgicon5\Svgicon5.csproj"

# アプリケーションを実行する関数
function Run(){
    # dotnet run コマンドを実行
    dotnet run --project $csproj
}

# アプリケーションを停止する関数
function Stop-App($appName){
    # アプリケーションのプロセスを取得
    Get-Process -Name $appName -ErrorAction SilentlyContinue
    if ($?) {
        # プロセスが存在する場合、停止する
        Stop-Process -Name $appName
    }
    # 少し待つ
    Start-Sleep -Milliseconds 500
}

# ファイルまたはディレクトリを削除する関数
function Remove($files, $appName) {
    # アプリケーションを停止
    Stop-App $appName
    # ファイルまたはディレクトリが存在する場合、削除する
    if (Test-Path $files) {
        Remove-Item -Recurse -Force $files
    }
}

# ショートカットを作成する関数
function Create-Shortcut($target, $linkName){
    # WScript.Shell オブジェクトを作成
    $WshShell = New-Object -ComObject WScript.Shell
    # デスクトップのパスを取得
    $desktop = [System.Environment]::GetFolderPath("Desktop")
    # ショートカットを作成
    $Shortcut = $WshShell.CreateShortcut("$desktop\$linkName")
    $Shortcut.TargetPath = $target
    $Shortcut.Save()
}

# プロジェクトをビルドする関数
function Build($projectFile, $appName) {
    # アプリケーションを停止
    Stop-App $appName
    # dotnet publish コマンドを実行
    dotnet publish $projectFile -c Release -r win10-x64
}

# パッケージを圧縮する関数
function Compress-Package($binDir){
    # ビルドディレクトリのサブディレクトリ名を取得
    $subDir = (Get-ChildItem "$binDir\x64\Release")[0].Name
    # 圧縮対象のパスを指定
    $target = "$binDir\x64\Release\$subDir\win10-x64"
    # 圧縮する
    Compress-Archive -Path $target,README.md,dev.ps1,LICENSE.txt,installer.nsh,SVG2ICO.ico -DestinationPath "SVG2ICO.zip" -Force
}

# コマンドライン引数によって処理を分岐
if ($Args[0] -eq "run") {
    Run
} elseif ($Args[0] -eq "uninstall") {
    # アンインストール処理
    $bin = "$env:USERPROFILE\AppData\Local"
    $appName = "Svg2Ico"

    # アプリケーションが実行中の場合は停止
    Get-Process -Name $appName -ErrorAction SilentlyContinue
    if($?){
        Stop-Process -Name $appName
    }
    Start-Sleep -Milliseconds 500

    # アプリケーションのディレクトリが存在する場合は削除
    $installDir = "$bin\$appName"
    if(Test-Path -Path $installDir){
        Remove-Item -Path $installDir -Recurse -Force
    }

    # デスクトップのショートカットを削除
    $desktop = [System.Environment]::GetFolderPath("Desktop")
    $shortcutPath = "$desktop\Svgicon5.lnk"
    if(Test-Path -Path $shortcutPath){
        Remove-Item -Path $shortcutPath -Force
    }

} elseif ($Args[0] -eq "install"){
    # インストール処理
    $bin = "$env:USERPROFILE\AppData\Local"
    $appName = "Svg2Ico"
    $rawAppName = "Svgicon5"

    # アプリケーションが実行中の場合は停止
    Get-Process -Name $rawAppName -ErrorAction SilentlyContinue
    if($?){
        Stop-Process -Name $rawAppName
    }
    Start-Sleep -Milliseconds 500

    # アプリケーションのディレクトリが存在する場合は削除
    $installDir = "$bin\$appName"
    if(Test-Path -Path $installDir){
        Remove-Item -Path $installDir -Recurse -Force
    }

    # ビルドディレクトリを削除
    Remove-Item -Recurse -Force .\Svgicon5\bin

    # リリースモードでビルド
    dotnet build Svgicon5\Svgicon5.csproj -c Release -r win10-x64

    # アプリケーションのディレクトリをコピー
    $buildDst = ".\Svgicon5\bin\x64\Release"
    $releaseDir = (Get-ChildItem $buildDst)[0].Name
    Copy-Item -Recurse "$buildDst\$releaseDir\win10-x64" $installDir

    # デスクトップにショートカットを作成
    $WshShell = New-Object -ComObject WScript.Shell
    $desktop = [System.Environment]::GetFolderPath("Desktop")
    $Shortcut = $WshShell.CreateShortcut("$desktop\SVG2ICO.lnk")
    $Shortcut.TargetPath = "$env:USERPROFILE\AppData\Local\Svg2Ico\SVG2ICO.exe"
    $Shortcut.Save()
} elseif ($Args[0] -eq "pack"){
    # パッケージ作成処理
    Remove "Svgicon5\bin" "SVG2ICO"
    Build "Svgicon5\Svgicon5.csproj" "SVG2ICO"
    Compress-Package "Svgicon5\bin"
} elseif ($Args[0] -eq "nsis"){
    $version = (Get-Date).ToString("yy.M.d")
    $date = (Get-Date).ToString("yyyyMMdd")
    $size = [Math]::Round((Get-ChildItem .\Svgicon5\bin\x64\Release\net7.0-windows10.0.19041.0 -Force -Recurse -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum / 1KB, 0, [MidpointRounding]::AwayFromZero)
    .'C:\Program Files (x86)\NSIS\makensis.exe' /DVERSION="$version" /DDATE="$date" /DSIZE="$size" installer.nsh
}