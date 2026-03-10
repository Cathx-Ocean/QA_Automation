param (
    [string]$DriverDir = "drivers"
)

if (-Not (Test-Path $DriverDir)) {
    New-Item -ItemType Directory -Path $DriverDir | Out-Null
}

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
if (-Not (Test-Path $chromePath)) {
    $chromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
}
if (-Not (Test-Path $chromePath)) {
    throw "❌ Google Chrome not found after install!"
}

$chromeVersion = (Get-Item $chromePath).VersionInfo.ProductVersion
$majorVersion = $chromeVersion.Split('.')[0]

Write-Host "Detected Chrome version: $chromeVersion"

$driverVersion = Invoke-RestMethod "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$majorVersion"
Write-Host "Matching ChromeDriver version: $driverVersion"

$zipPath = "$DriverDir\chromedriver.zip"
Invoke-WebRequest "https://chromedriver.storage.googleapis.com/$driverVersion/chromedriver_win32.zip" -OutFile $zipPath

Expand-Archive -Path $zipPath -DestinationPath $DriverDir -Force
Remove-Item $zipPath

Write-Host "✅ ChromeDriver downloaded to $DriverDir"
