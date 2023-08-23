$minIndex = 0
$maxIndex = 1

Write-Host "> Install"
Write-Host "  Uninstall" -nonewline
$Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, ($Host.UI.RawUI.CursorPosition.Y - 1))
$key = $Host.UI.RawUI.ReadKey()
$keyCode = $key.VirtualKeyCode
$selectIndex = 0

while ($true) {
    if ($keyCode -eq 38) {
        if ($selectIndex -ne $minIndex) {
            Write-Host "> Install"
            Write-Host "  Uninstall" -nonewline
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, ($Host.UI.RawUI.CursorPosition.Y - 1))
            $selectIndex -= 1
        }
    }
    elseif ($keyCode -eq 40) {
        if ($selectIndex -ne $maxIndex) {
            Write-Host "  Install"
            Write-Host "> Uninstall" -nonewline
            $Host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates(0, ($Host.UI.RawUI.CursorPosition.Y - 1))
            $selectIndex += 1
        }
    }
    $key = $Host.UI.RawUI.ReadKey()
    $keyCode = $key.VirtualKeyCode

}
