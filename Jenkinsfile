pipeline {
    agent any
    //git 'https://github.com/ALutchko/poc'

    stages {
        stage('Test') {
            steps {
                echo 'Testing..'
                checkout scm
                dir("tmp"){
                    sh 'ls -laR ~/.aws/'
                    sh 'aws --version'
                    sh 'aws sts get-caller-identity'
                }
            }
        }
        /*stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }*/
    }
}