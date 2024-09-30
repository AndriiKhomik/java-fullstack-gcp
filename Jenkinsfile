pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/AndriiKhomik/java-fullstack-gcp.git'
         GCP_CREDS = credentials('gcp-credentials.json') 
    }

    tools {
        nodejs 'NodeJS 16.x'
        gradle 'Gradle 7.5'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        // stage('Build Backend') {
        //     steps {
        //         echo 'Building backend...'
        //         sh 'gradle build -x test'
        //         stash name: 'backend-artifact', includes: '**/target/*.war'
        //     }
        // }
        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    echo 'Building frontend...'
                    sh 'npm run build'
                    stash name: 'frontend-artifact', includes: 'build/**/*'
                }
            }
        }
        stage('Provision Infracstructure') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                        frontend_vm_ip=$(terraform output -raw frontend_vm_ip)
                        user_name=$(terraform output -raw user_name)
                        echo "FRONTEND_VM_IP=${frontend_vm_ip}" >> env.properties
                        echo "USER_NAME=${user_name}" >> env.properties
                    '''
                    script {
                        def props = readProperties file: 'env.properties'
                        env.FRONTEND_VM_IP = props['FRONTEND_VM_IP']
                        env.USER_NAME = props['USER_NAME']
                    }
                }
            }
        }
        stage('Deploy artifacts') {
            steps {
                script {
                    unstash 'frontend-artifact'
                    withCredentials([sshUserPrivateKey(credentialsId: 'gcp-credentials.json', keyFileVariable: 'GCP_CREDS')]) {
                        sh '''
                            scp -i ${GCP_CREDS} -r build/* ${USER_NAME}@${env.FRONTEND_VM_IP}:/var/www/html/
                        '''
                    }
                }
            }
        }
    }
    // post {
    //     always {
    //         cleanWs()
    //     }
    // }
}
