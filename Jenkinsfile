pipeline {
    agent { label "ec2-fleet" }
    environment {
        TF_IN_AUTOMATION = 1
        TF_url = "https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip"
        TF_zip = "terraform_0.12.29_linux_amd64.zip"
    }
    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '100'))
        timestamps()
        ansiColor('xterm')
    }
    stages {
        stage('Prepare env') {
            parallel {
                stage('AWS CLI') {
                    steps {
                        sh 'echo "Prepare env: $(date +%F-%H:%M:%S)"'
                        sh "echo 'NODE_NAME=${env.NODE_NAME}'"
                        // AWS CLI setup
                        sh """if [ ! -x ./aws ] ; then
                        echo re-setup needed
                        /bin/rm -rf aws aws_cli aws_dist aws_completer .kube
                        mkdir -p aws_cli && mkdir -p .kube
                        curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'
                        unzip -q -o awscliv2.zip
                        mv ./aws ./aws_dist  # to have aws executable as just './aws'
                        ./aws_dist/install -i  ./aws_cli/  -b ./
                        # little hack because aws installer is broken if you run it as non-root
                        ln -f -s ./aws_cli/v2/\$(ls ./aws_cli/v2/ | grep 2)/dist/aws ./aws
                        /bin/rm -rf ./aws_completer ./aws_dist awslogs-agent-setup.py ./current
                        # aws default setup
                        mkdir -p ~/.aws # don't mess './aws' with '.aws'!!!
                        echo \"[default]\noutput = json\nregion = eu-central-1\n\" > ~/.aws/config
                        ls -laR ~/.aws/
                        # aws ec2 describe-instances
                        fi
                        ./aws --version
                        ./aws sts get-caller-identity
                        """
                    }
                }
                stage('Terraform') {
                    steps {
                        sh """if [ ! -x ./terraform ] ; then
                        wget -nv ${TF_url}
                        unzip -o ${TF_zip}
                        /bin/rm ${TF_zip}
                        fi
                        ./terraform -v
                        """
                    }
                }
            }
        }
        stage('Test') {
            environment {
                TF_LOG = ''
                TF_INPUT = 0
                //TF_VAR_GITHUB_CREDENTIALS = credentials('dodaxbuilder-rsa-dev01')
            }
            steps {
                    sh 'echo "Validating: $(date +%F-%H:%M:%S)"'
                    checkout scm
                    sh """
                    /bin/rm -rf ./.terraform terraform.tfstate terraform.tfstate.backup
                    ls -la
                    #export TF_LOG=DEBUG
                    ./terraform init
                    #export TF_LOG=
                    ./terraform validate
                    """
                //}
            }
        }
        stage('apply') {
            steps {
                sh 'echo "Apply: $(date +%F-%H:%M:%S)"'
                sh """
                chmod 700 ./adduser.sh
                ls -la
                #./terraform destroy -auto-approve -input=false; exit 0
                #export TF_LOG=DEBUG
                ./terraform plan -input=false
                export TF_LOG=
                ./terraform apply -auto-approve -input=false

                """
            }
        }
    }
}