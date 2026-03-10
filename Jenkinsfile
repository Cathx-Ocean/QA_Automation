pipeline {
    agent any

    environment {
        VENV_DIR   = '.venv'
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
                bat 'where chromedriver || echo ChromeDriver not found'
                bat 'where chrome || echo Chrome not found'
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
                script {
                    def cmd1 = 'Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force'
                    def cmd2 = './scripts/install_chrome.ps1'
                    powershell cmd1
                    powershell cmd2
                }
            }
        }

        stage('Download Matching ChromeDriver') {
            steps {
                script {
                    def cmd1 = 'Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force'
                    def cmd2 = "./scripts/download_chromedriver.ps1 -DriverDir ${env.DRIVER_DIR}"
                    powershell cmd1
                    powershell cmd2
                }
            }
        }

        stage('Run Selenium Tests') {
            steps {
                script {
                    bat """
                        call %VENV_DIR%\\Scripts\\activate
                        mkdir %REPORT_DIR%
                        pytest --junitxml=%REPORT_DIR%\\results.xml --html=%REPORT_DIR%\\report.html --self-contained-html
                    """
                }
            }
        }

        stage('Publish Test Results') {
            steps {
                junit allowEmptyResults: true, testResults: "${REPORT_DIR}/results.xml"
                archiveArtifacts artifacts: "${REPORT_DIR}/report.html", fingerprint: true
            }
        }
    }

    post {
        always {
            echo '🏁 Pipeline finished'
            cleanWs()
        }
        failure {
            echo '❌ Build failed. Check test reports for details.'
        }
    }
}
