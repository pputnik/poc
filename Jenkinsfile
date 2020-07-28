pipeline {
    agent { label "ec2-fleet" }
    stages {
        stage('Prepare env') {
            steps {
                sh 'echo "Prepare env: $(date +%F-%H:%M:%S)"'
                sh "echo 'NODE_NAME=${env.NODE_NAME}'"
                // AWS CLI setup
                sh """if [ ! -x ./aws ] ; then
                echo re-setup needed
                /bin/rm -rf aws aws_cli aws_dist aws_completer && mkdir -p aws_cli
                curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'
                unzip -q -o awscliv2.zip
                mv ./aws ./aws_dist  # to have aws executable as just './aws'
                ./aws_dist/install -i  ./aws_cli/  -b ./
                # little hack because aws installer is broken if you run it as non-root
                ln -f -s ./aws_cli/v2/\$(ls ./aws_cli/v2/ | grep 2)/dist/aws ./aws
                /bin/rm -rf ./aws_completer ./aws_dist awslogs-agent-setup.py ./current
                // aws default setup
                mkdir -p ~/.aws # don't mess './aws' with '.aws'!!!
                echo \"[default]\noutput = json\nregion = eu-central-1\n\" > ~/.aws/config
                ls -laR ~/.aws/
                # aws ec2 describe-instances
                ./aws sts get-caller-identity
                fi
                ./aws --version
                """
                sh 'wget -nv https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip'
                sh 'unzip -o terraform_0.12.29_linux_amd64.zip && /bin/rm terraform_0.12.29_linux_amd64.zip'
                sh './terraform -v'
                sh 'ls -l'
            }
        }
        stage('Test') {
            environment {
                TF_IN_AUTOMATION = 1
                TF_LOG = 'TRACE'
                //TF_VAR_GITHUB_CREDENTIALS = credentials('dodaxbuilder-rsa-dev01')
            }
            steps {
                withCredentials(bindings: [sshUserPrivateKey( \
                    credentialsId: 'dodaxbuilder-rsa-dev01', \
                    keyFileVariable: 'git_key', \
                    usernameVariable: 'git' \
                )]) {
                    sh 'echo "Validating: $(date +%F-%H:%M:%S)"'
                    checkout scm
                    sh("""
                    git config credential.username {GIT_USERNAME}
                    git config credential.helper "!echo password={GITPASSWORD}; echo"
                    #git clone {your_repository}
                    """)
                    sh './terraform init -input=false -no-color'
                    sh './terraform validate -no-color'
                }
            }
        }
        /*stage('apply') {
            steps {
                sh 'echo "Apply: $(date +%F-%H:%M:%S)"'
                sh 'export TF_IN_AUTOMATION=1'
                sh './terraform apply -auto-approve -input=false -no-color'
            }
        }*/
    }
    /*post {
        always {
            do something
        }
        failure {
            mail to: alutchko@dodax.com, subject: 'The Pipeline failed :('
        }
    }*/
}