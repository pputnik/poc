pipeline {
    agent any
    git 'https://github.com/ALutchko/poc'

    stages {
        stage('Test') {
            steps {
                echo 'Testing..'
                checkout scm
                dir("tmp"){
                    sh 'pwd'
                    sh 'ls -la'
                    sh 'set'
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