pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/AndriiKhomik/java-fullstack-gcp.git'
    }

    tools {
        // nodejs 'NodeJS 16.x'
        gradle 'Gradle 7.5'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Building backend...'
                sh 'gradle build -x test'
            }
        }
    }
}