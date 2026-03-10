pipeline {
    agent any

    environment {
        VENV_DIR = '.venv'
        REPORT_DIR = 'reports'
        DRIVER_DIR = 'drivers'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo '✅ Checkout complete'
            }
        }

        stage('Environment Info') {
            steps {
                bat 'ver'
                bat 'where python'
                bat 'python --version'
                bat 'where chromedriver'
                bat 'where chrome'
            }
        }

        stage('PowerShell Test') {
            steps {
                powershell '''
                    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
                    Write-Host "✅ PowerShell is working"
                '''
            }
        }

        stage('Setup Python Environment') {
            steps {
                bat """
                    python -m venv %VENV_DIR%
                    call %VENV_DIR%\\Scripts\\activate
                    pip install --upgrade pip
                    if exist requirements.txt pip install -r requirements.txt
                """
            }
        }

        stage('Ensure Google Chrome Installed') {
            steps {
                powershell '''
                    $chromePath1 = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
                    $chromePath2 = "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe"

                    if (-Not (Test-Path $chromePath1) -and -Not (Test-Path $chromePath2)) {
                        Write-Host "⚠ Google Chrome not found. Installing..."
                        $chromeInstaller = "$env:TEMP\\chrome_installer.exe"
                        Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $chromeInstaller
                        Start-Process $chromeInstaller -ArgumentList "/silent", "/install" -Wait
                        Remove-Item $chromeInstaller
                        Write-Host "✅ Google Chrome installed."
                    } else {
                        Write-Host "✅ Google Chrome already installed."
                    }
                '''
            }
        }

        stage('Download Matching ChromeDriver') {
            steps {
                powershell '''
                    if (-Not (Test-Path $env:DRIVER_DIR)) { New-Item -ItemType Directory -Path $env:DRIVER_DIR | Out-Null }

                    $chromePath = "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe"
                    if (-Not (Test-Path $chromePath)) { $chromePath = "C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe" }
                    if (-Not (Test-Path $chromePath)) { throw '❌ Google Chrome not found after install!' }

                    $chromeVersion = (Get-Item $chromePath).VersionInfo.ProductVersion
                    $majorVersion = $chromeVersion.Split('.')[0]

                    Write-Host "Detected Chrome version: $chromeVersion"

                    $driverVersion = Invoke-RestMethod "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$majorVersion"
                    Write-Host "Matching ChromeDriver version: $driverVersion"

                    $zipPath = "$env:DRIVER_DIR\\chromedriver.zip"
                    Invoke-WebRequest "https://chromedriver.storage.googleapis.com/$driverVersion/chromedriver_win32.zip" -OutFile $zipPath

                    Expand-Archive -Path $zipPath -DestinationPath $env:DRIVER_DIR -Force
                    Remove-Item $zipPath

                    Write-Host "✅ ChromeDriver downloaded to $env:DRIVER_DIR"
                '''
            }
        }
    }

    post {
        always {
            echo '🏁 Step 3 pipeline finished'
        }
    }
}
