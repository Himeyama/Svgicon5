# SVG2ICO
SVG2ICOは、SVG画像をICOに変換するソフトウェアです。

<image width="600" src="https://github.com/Himeyama/Svgicon5/assets/39254183/c11780e5-4239-4922-9765-f044516289b0" />

## パッケージのインストール
1. `SVG2ICO`を解凍します。

2. コンピュータにPotableInstallerがインストールされている場合は、PotableInstaller.lnkをクリックします。
   そうでない場合は、次のステップ（3.）に進みます。

3. PowerShellで`onlineInstall.ps1`を実行します。
   ソフトウェアをインストールできない場合は、以下のコマンドを実行してみてください。

    ```ps1
    Set-ExecutionPolicy RemoteSigned
    ```
    
## 開発ツール

### 実行
```ps1
./dev run
```

### インストール
```ps1
./dev install
```

### アンインストール
```ps1
./dev uninstall
```

### zip を生成
```ps1
./dev pack
```
