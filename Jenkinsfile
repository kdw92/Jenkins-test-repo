pipeline {
    agent any
    options {
        timeout(time: 1, unit: 'HOURS') // set timeout 1 hour
    }
    environment {
        TIME_ZONE = 'Asia/Seoul'
        PROFILE = 'local'
        
        REPOSITORY_CREDENTIAL_ID = 'test'
        REPOSITORY_URL = 'https://github.com/Kogoon/Jenkins-test-repo.git'
        TARGET_BRANCH = 'main'
        
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
        stage('clone project') {
            steps {
                git url: "$REPOSITORY_URL",
                    branch: "$TARGET_BRANCH",
                    credentialsId: "$REPOSITORY_CREDENTIAL_ID"
                sh "ls -al"
            }
            post {
                success {
                    echo 'success clone project'
                }
                failure {
                    error 'fail clone project' // exit pipeline
                }
            }
        }
        stage('build project') {
            steps {
                sh '''
        		 ./gradlew bootJar
        		 '''
            }
            post {
                success {
                    echo 'success build project'
                }
                failure {
                    error 'fail build project' // exit pipeline
                }
            }
        }
        stage('dockerizing project by dockerfile') {
            steps {
                sh '''
        		 docker build -t $IMAGE_NAME:$BUILD_NUMBER .
        		 docker tag $IMAGE_NAME:$BUILD_NUMBER $IMAGE_NAME:latest

        		 '''
            }
            post {
                success {
                    echo 'success dockerizing project'
                }
                failure {
                    error 'fail dockerizing project' // exit pipeline
                }
            }
        }
        stage('upload aws ECR') {
            steps {
                script{
                    // cleanup current user docker credentials
                    sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'
                   
                    withAWS(credentials:'AWS_ECR', region:'ap-northeast-2') {
                        sh "aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${ECR_PATH}"
                      sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                      sh "docker push ${IMAGE_NAME}:latest"
                    }

                }
            }
            post {
                success {
                    echo 'success upload image'
                }
                failure {
                    error 'fail upload image' // exit pipeline
                }
            }
        }
    }
}
