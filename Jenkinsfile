pipeline {
    agent { label "ec2-fleet" }
    stages {
        stage("Git creds"){
            withCredentials([sshUserPrivateKey(credentialsId: 'dodaxbuilder-rsa-dev01', keyFileVariable: 'git_key', passphraseVariable: 'git_passphrase', usernameVariable: 'git_user')]) {
                sh("""
                git config credential.username {GIT_USERNAME}
                git config credential.helper "!echo password={GITPASSWORD}; echo"
                #git clone {your_repository}
                """)
            }
        }


        stage('Prepare env') {
            steps {
                sh 'echo "Prepare env: $(date +%F-%H:%M:%S)"'
                // AWS CLI setup
                sh 'if [ ! -x ./aws ] ; then echo re-setup needed; fi'
                sh '/bin/rm -rf aws aws_cli aws_dist aws_completer && mkdir -p aws_cli'
                sh 'curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"'
                sh 'unzip -q -o awscliv2.zip'
                sh 'mv ./aws ./aws_dist'    // to have aws executable as just './aws'
                sh './aws_dist/install -i  ./aws_cli/  -b ./'
                // little hack because aws installer is broken if you run it as non-root
                sh 'ln -f -s ./aws_cli/v2/$(ls ./aws_cli/v2/ | grep 2)/dist/aws ./aws'
                sh './aws --version'
                sh '/bin/rm -rf ./aws_completer ./aws_dist awslogs-agent-setup.py ./current'
                // aws default setup
                sh 'mkdir -p ~/.aws'    // don't mess './aws' with '.aws'!!!
                sh 'echo "[default]\noutput = json\nregion = eu-central-1\n" > ~/.aws/config'
                sh 'ls -laR ~/.aws/'
                //sh 'aws ec2 describe-instances'
                sh './aws sts get-caller-identity'
                sh 'wget -nv https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip'
                sh 'unzip -o terraform_0.12.29_linux_amd64.zip && /bin/rm terraform_0.12.29_linux_amd64.zip'
                sh './terraform -v'
                sh 'ls -l'
            }
        }
        stage('Test') {
            steps {
                sh 'echo "Validating: $(date +%F-%H:%M:%S)"'
                checkout scm
                sh 'export TF_IN_AUTOMATION=1'
                sh 'export TF_LOG=DEBUG'
                sh './terraform init -input=false -no-color'
                sh './terraform validate -no-color'
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
}