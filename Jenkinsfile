pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo "✅ Checkout complete"
            }
        }

        stage('Show Jenkinsfile Path') {
            steps {
                script {
                    echo "Workspace: ${env.WORKSPACE}"
                    echo "Jenkinsfile path: ${env.WORKSPACE}\\Jenkinsfile"
                }
            }
        }

        stage('Print Jenkinsfile Contents') {
            steps {
                bat 'type Jenkinsfile'
            }
        }
    }
}
