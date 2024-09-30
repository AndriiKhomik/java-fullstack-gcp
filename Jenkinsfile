pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/AndriiKhomik/java-fullstack-gcp.git'
        GCP_CREDS = credentials('gcp-credentials') 

        POSTGRES_USER = credentials('postgres_user')
        POSTGRES_PASSWORD = credentials('postgres_password')
        POSTGRES_DB = credentials('postgres_db')
        MONGO_INITDB_ROOT_USERNAME = credentials('mongo_init_root_username')
        MONGO_INITDB_ROOT_PASSWORD = credentials('mongo_init_root_password')
        REACT_APP_API_BASE_URL = credentials('react_apibase_url')
    }

    tools {
        nodejs 'NodeJS 14.x'
        gradle 'Gradle 7.5'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Backend') {
            steps {
                echo 'Building backend...'
                sh 'gradle build -x test'
                stash name: 'backend-artifact', includes: '**/target/*.war'
            }
        }
        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    echo 'Building frontend...'
                    sh 'npm install'
                    sh 'npm run build'
                    stash name: 'frontend-artifact', includes: 'build/**/*'
                }
            }
        }
        stage('Save Artifacts Locally') {
            steps {
                unstash 'backend-artifact'
                unstash 'frontend-artifact'

                sh '''
                    mkdir -p ~/jenkins_artifacts/backend
                    mkdir -p ~/jenkins_artifacts/frontend

                    cp **/target/*.war ~/jenkins_artifacts/backend
                    cp -r frontend/build/* ~/jenkins_artifacts/frontend
                '''
            }
        }
        // stage('Provision Infracstructure') {
        //     steps {
        //         dir('terraform') {
        //             sh '''
        //                 terraform init
        //                 terraform apply -auto-approve
        //                 // terraform apply -auto-approve -var "public_key_file=id_rsa.pub"
        //                 frontend_vm_ip=$(terraform output -raw frontend_vm_ip)
        //                 user_name=$(terraform output -raw user_name)
        //                 echo "FRONTEND_VM_IP=${frontend_vm_ip}" >> env.properties
        //                 echo "USER_NAME=${user_name}" >> env.properties
        //             '''
        //             script {
        //                 def props = readProperties file: 'env.properties'
        //                 env.FRONTEND_VM_IP = props['FRONTEND_VM_IP']
        //                 env.USER_NAME = props['USER_NAME']
        //             }
        //         }
        //     }
        // }
        // stage('Deploy artifacts') {
        //     steps {
        //         script {
        // use rsync for this purpose !!!!!!!!
        //             unstash 'frontend-artifact'
        //             withCredentials([sshUserPrivateKey(credentialsId: 'jenkins', keyFileVariable: 'SSH_KEY')]) {
        //                 sh '''
        //                     scp -i ${SSH_KEY} -r build/* ${USER_NAME}@${env.FRONTEND_VM_IP}:/var/www/html/
        //                 '''
        //             }
        //         }
        //     }
        // }
    }
    post {
        always {
            cleanWs()
        }
    }
}
