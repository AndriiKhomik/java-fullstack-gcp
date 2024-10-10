pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/AndriiKhomik/java-fullstack-gcp.git'
        GCP_KEY = credentials('gcp-key')

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
                        backend_vm_ip=$(terraform output -raw backend_vm_ip)
                        mongodb_vm_ip=$(terraform output -raw mongodb_vm_ip)
                        postgres_vm_ip=$(terraform output -raw postgres_vm_ip)
                        redis_vm_ip=$(terraform output -raw redis_vm_ip)
                        echo "nginx_server=${frontend_vm_ip}" >> ../.env
                        echo "mongo_server=${mongodb_vm_ip}" >> ../.env
                        echo "tomcat_server=${backend_vm_ip}" >> ../.env
                        echo "postgres_server=${postgres_vm_ip}" >> ../.env
                        echo "redis_server=${redis_vm_ip}" >> ../.env
                        echo end
                    '''
                }
            }
        }
        stage('Change IPs in ansible config'){
            steps {
                sh './change_ips.sh .env ./ansible/inventory.yml'
            }
        }
        stage('Add to known host') {
            steps {
                sh './add_to_known_hosts.sh .env'
            }
        }
        stage('Build Backend') {
            steps {
                echo 'Building backend...'
                withEnv([
                    "POSTGRES_USER=${env.POSTGRES_USER}",
                    "POSTGRES_PASSWORD=${env.POSTGRES_PASSWORD}",
                    "POSTGRES_DB=${env.POSTGRES_DB}",
                    "MONGO_INITDB_ROOT_USERNAME=${env.MONGO_INITDB_ROOT_USERNAME}",
                    "MONGO_INITDB_ROOT_PASSWORD=${env.MONGO_INITDB_ROOT_PASSWORD}",
                    "REACT_APP_API_BASE_URL=${env.REACT_APP_API_BASE_URL}"
                ]) {
                    sh 'gradle clean build -x test'
                }
            }
        }
        stage('Archive backend') {
            steps {
                archiveArtifacts(artifacts: '**/build/libs/*.war', followSymlinks: false)
            }
        }
        stage('Build Frontend') {
            steps {
                dir('frontend') {
                    echo 'Building frontend...'
                    withEnv([
                        "REACT_APP_API_BASE_URL=${env.REACT_APP_API_BASE_URL}"
                    ])
                    {
                        sh 'npm install'
                        sh 'npm run build'
                    }
                }
            }
        }
        stage('Archive frontend') {
            steps {
                dir('frontend') {
                    sh 'tar -czf build.tar.gz build'
                    archiveArtifacts(artifacts: 'build.tar.gz', followSymlinks: false)
                }
            }
        }
        stage('Copy files to appropriate folders') {
            steps {
                script {
                    sh "mv /var/lib/jenkins/jobs/artifacts-test/builds/${BUILD_NUMBER}/archive/build/libs/class_schedule.war /var/lib/jenkins/workspace/artifacts-test/ansible/java-app/tomcat/files/ROOT.war" 
                    sh "mv /var/lib/jenkins/jobs/artifacts-test/builds/${BUILD_NUMBER}/archive/build.tar.gz /var/lib/jenkins/workspace/artifacts-test/ansible/java-app/nginx/files"
                    sh "tar -xzvf /var/lib/jenkins/workspace/artifacts-test/ansible/java-app/nginx/files/build.tar.gz -C /var/lib/jenkins/workspace/artifacts-test/ansible/java-app/nginx/files/"
                }
            }
        }
        stage('Run ansible') {
            steps {
                dir('ansible') {
                    sh '''
                        ansible-playbook -i ./inventory.yml ./java-app/nginx-role.yml --private-key="$GCP_KEY"
                        ansible-playbook -i ./inventory.yml ./java-app/redis-role.yml --private-key="$GCP_KEY"
                        ansible-playbook -i ./inventory.yml ./java-app/postgres-role.yml --private-key="$GCP_KEY"
                        ansible-playbook -i ./inventory.yml ./java-app/mongodb-role.yml --private-key="$GCP_KEY"
                    '''
                }
            }
        }
    }
}
