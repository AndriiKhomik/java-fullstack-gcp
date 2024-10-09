pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/AndriiKhomik/java-fullstack-gcp.git'

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
        // TODO: Test and remove
        // maven 'Maven'
        // jdk 'Java 11'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Create .env file') {
            steps {
                sh '''
                    touch .env
                    > .env
                '''
            }
        }
        stage('Provision Infracstructure') {
            steps {
                dir('terraform') {
                    sh '''
                        terraform init -upgrade
                        terraform apply -auto-approve
                        frontend_vm_ip=$(terraform output -raw frontend_vm_ip)
                        echo "FRONTEND_VM_IP=${frontend_vm_ip}"
                        echo "nginx_server=${frontend_vm_ip}" > ../.env
                        echo end
                    '''
                }
            }
        }
        stage('Change IPs in ansible config'){
            steps {
                sh './change_ips.sh .env ./ansible/inventory.yml '
            }
        }
        stage('Run ansible') {
            steps {
                dir('ansible') {
                    sh 'pwd'
                    sh 'ls -al'
                    // sh 'ansible-playbook -i ./inventory.yml .java-app/nginx-role.yml'
                }
            }
        }
        // stage('Build Backend') {
        //     steps {
        //         echo 'Building backend...'
        //         withEnv([
        //             "POSTGRES_USER=${env.POSTGRES_USER}",
        //             "POSTGRES_PASSWORD=${env.POSTGRES_PASSWORD}",
        //             "POSTGRES_DB=${env.POSTGRES_DB}",
        //             "MONGO_INITDB_ROOT_USERNAME=${env.MONGO_INITDB_ROOT_USERNAME}",
        //             "MONGO_INITDB_ROOT_PASSWORD=${env.MONGO_INITDB_ROOT_PASSWORD}",
        //             "REACT_APP_API_BASE_URL=${env.REACT_APP_API_BASE_URL}"
        //         ]) {
        //             sh 'gradle clean build -x test'
        //         }
        //     }
        // }
        // stage('Archive backend') {
        //     steps {
        //         archiveArtifacts(artifacts: '**/build/libs/*.war', followSymlinks: false)
        //     }
        // }
        // stage('Build Frontend') {
        //     steps {
        //         dir('frontend') {
        //             echo 'Building frontend...'
        //             withEnv([
        //                 "REACT_APP_API_BASE_URL=${env.REACT_APP_API_BASE_URL}"
        //             ])
        //             {
        //                 sh 'npm install'
        //                 sh 'npm run build'
        //             }
        //         }
        //     }
        // }
        // stage('Archive frontend') {
        //     steps {
        //         dir('frontend') {
        //             sh 'tar -czf build.tar.gz build'
        //             // archiveArtifacts(artifacts: 'frontend/build/**/*', followSymlinks: false)
        //             archiveArtifacts(artifacts: 'build.tar.gz', followSymlinks: false)
        //         }
        //     }
        // }
        // stage('Archive artifact') {
        //     steps {
        //         unstash 'frontend-artifact'
        //         archiveArtifacts(artifacts: build, followSymlinks: false)
        //     }
        // }
        // stage('Save Artifacts Locally') {
        //     steps {
        //         unstash 'backend-artifact'
        //         unstash 'frontend-artifact'

        //         sh '''
        //             mkdir -p ~/jenkins_artifacts/backend
        //             mkdir -p ~/jenkins_artifacts/frontend

        //             cp build/libs/*.war ~/jenkins_artifacts/backend
        //             cp -r frontend/build/* ~/jenkins_artifacts/frontend
        //         '''
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
    // post {
    //     always {
    //         cleanWs()
    //     }
    // }
}
