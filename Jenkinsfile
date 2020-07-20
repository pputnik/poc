pipeline {
    //agent any
    agent { label "ec2-fleet" }


    stages {
        stage('Test') {
            steps {
                echo 'Testing..'
                checkout scm
                dir("tmp"){
                    sh 'aws --version'
                    /*sh 'python --version'
                    sh 'echo $PATH'
                    sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
                    sh 'unzip awscliv2.zip'
                    sh './aws/install -i ./ '
                    sh 'ls -la ./aws/'
                    sh 'ls -laR ~/.aws/'*/
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