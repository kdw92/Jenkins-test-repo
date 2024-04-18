pipeline {
    agent any
	
    stages {
        stage('Build') {
	    environment {
	        GITHUB_TOKEN = credentials('kogoon')
	    }
            steps {
                echo 'Building..'
                checkout scm
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
