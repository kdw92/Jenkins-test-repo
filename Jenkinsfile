pipeline {
    agent any
    options {
    timeout(time: 1, unit: 'HOURS') // set timeout 1 hour
    }
    
    environment {
        
        TIME_ZONE = 'Asia/Seoul'
        
        //github
        TARGET_BRANCH = 'main'
        REPOSITORY_URL= 'https://github.com/Kogoon/Jenkins-test-repo'

        //docker-hub
        registryCredential = 'docker-hub'

        //aws ecr
        
        CONTAINER_NAME = 'jigreg-test'
        AWS_CREDENTIAL_NAME = 'jigreg-jenkins'
        ECR_PATH = '730335492431.dkr.ecr.ap-northeast-2.amazonaws.com'
        IMAGE_NAME = '730335492431.dkr.ecr.ap-northeast-2.amazonaws.com/jigreg-test'
        REGION = 'ap-northeast-2'
    }

    

    stages {


        stage('init') {
            steps {
                echo 'init stage'
                deleteDir()
            }
            post {
                success {
                    echo 'success init in pipeline'
                }
                failure {
                    error 'fail init in pipeline'
                }
            }
        }
        
        stage('Prepare') {
            steps {
                echo 'Cloning Repository'
                git branch: 'main', 
                    credentialsId: 'kogoon', 
                    url: 'https://github.com/Kogoon/Jenkins-test-repo'
            }
            post {
                success {
                    echo 'Successfully Cloned Repository'
                }
                failure {
                    error 'This pipeline stops here...'
                }
            }
        }
       // 도커 이미지를 만든다. build number로 태그를 주되 latest 태그도 부여한다.
        stage('Build Docker') {
            steps {
                echo 'Build Docker'
                sh """
                    cd /var/jenkins_home/workspace/teamPlannerBackEnd_jenkinsFile
                    docker builder prune
                    docker build -t $IMAGE_NAME:$BUILD_NUMBER .
                    docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest
                """
            }
            post {
                failure {
                    error 'This pipeline stops here...'
                }
            }
        }
       // 빌드넘버 태그와 latest 태그 둘 다 올린다.
        stage('Push Docker') {
            steps {
                echo 'Push Docker'
                script {
                    // cleanup current user docker credentials
                    sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'
                    
                    docker.withRegistry("https://${ECR_PATH}", "ecr:${REGION}:${AWS_CREDENTIAL_NAME}") {
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                        docker.image("${IMAGE_NAME}:latest").push()
                    }
                }
            }
            post {
                failure {
                    error 'This pipeline stops here...'
                }
            }
        }
  
    stage('Clean Up Docker Images on Jenkins Server') {
        steps {
            echo 'Cleaning up unused Docker images on Jenkins server'

            // Clean up unused Docker images, including those created within the last hour
            sh "docker image prune -f --all --filter \"until=1h\""
        }
    }

    }
