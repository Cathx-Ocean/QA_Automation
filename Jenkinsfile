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

        stage('Install Google Chrome') {
            steps {
                powershell "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force"
                powershell ".\\scripts\\install_chrome.ps1"
            }
        }

        stage('Download Matching ChromeDriver') {
            steps {
                powershell "Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force"
                powershell ".\\scripts\\download_chromedriver.ps1 -DriverDir '${DRIVER_DIR}'"
            }
        }
    }

    post {
        always {
            echo '🏁 Step 3 pipeline finished'
        }
    }
}