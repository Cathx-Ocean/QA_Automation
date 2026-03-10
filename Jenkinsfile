pipeline {
    agent {
        // Use a Python-enabled Jenkins agent (Docker or pre-installed Python)
        docker {
            image 'python:3.10'
            args '-u root:root' // Run as root to install packages if needed
        }
    }

    environment {
        // Virtual environment path
        VENV_DIR = '.venv'
        // Path to store test reports
        REPORT_DIR = 'reports'
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull latest code from repository
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    python -m venv $VENV_DIR
                    . $VENV_DIR/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Selenium Tests') {
            steps {
                sh '''
                    . $VENV_DIR/bin/activate
                    mkdir -p $REPORT_DIR
                    pytest --junitxml=$REPORT_DIR/results.xml --html=$REPORT_DIR/report.html --self-contained-html
                '''
            }
        }

        stage('Publish Test Results') {
            steps {
                // Publish JUnit XML results
                junit "$REPORT_DIR/results.xml"
                // Archive HTML report for viewing in Jenkins
                archiveArtifacts artifacts: "$REPORT_DIR/report.html", fingerprint: true
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            deleteDir()
        }
        failure {
            echo 'Build failed. Check test reports for details.'
        }
    }
}
