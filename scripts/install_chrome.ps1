$chromePath1 = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$chromePath2 = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

if (-Not (Test-Path $chromePath1) -and -Not (Test-Path $chromePath2)) {
    Write-Host "⚠ Google Chrome not found. Installing..."
    $chromeInstaller = "$env:TEMP\chrome_installer.exe"
    Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $chromeInstaller
    Start-Process $chromeInstaller -ArgumentList "/silent", "/install" -Wait
    Remove-Item $chromeInstaller
    Write-Host "✅ Google Chrome installed."
} else {
    Write-Host "✅ Google Chrome already installed."
}