pipeline {
    agent { label "ec2-fleet" }
    environment {
        TF_IN_AUTOMATION = 1
        TF_url = "https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip"
        TF_zip = "terraform_0.12.29_linux_amd64.zip"
        kubectl_url = "https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.7/2020-07-08/bin/linux/amd64/kubectl"
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
                stage('kubectl') {
                    steps {
                        sh """if [ ! -x ./kubectl ] ; then
                        curl -s -o kubectl ${kubectl_url}
                        chmod +x ./kubectl
                        fi
                        ./kubectl version --short --client
                        """
                    }
                }
            }
        }
        stage('Test') {
            environment {
                TF_LOG = 'INFO'
                TF_INPUT = 0
                //TF_VAR_GITHUB_CREDENTIALS = credentials('dodaxbuilder-rsa-dev01')
            }
            steps {
                /*withCredentials(bindings: [sshUserPrivateKey( \
                    credentialsId: 'dodaxbuilder-rsa-dev01', \
                    keyFileVariable: 'git_key', \
                    usernameVariable: 'git' \
                )]) {*/
                    sh 'echo "Validating: $(date +%F-%H:%M:%S)"'
                    checkout scm
                    /*sh("""
                    git config credential.username {GIT_USERNAME}
                    git config credential.helper "!echo password={GITPASSWORD}; echo"
                    #git clone {your_repository}
                    """)*/
                    sh """
                    /bin/rm -rf ./.terraform terraform.tfstate terraform.tfstate.backup
                    ls -la
                    #export TF_LOG=DEBUG
                    ./terraform init -no-color
                    export TF_LOG=INFO
                    ./terraform validate -no-color
                    """
                //}
            }
        }
        stage('apply') {
            steps {
                sh 'echo "Apply: $(date +%F-%H:%M:%S)"'
                sh """chmod 700 ./oidc-thumbprint.sh
                ls -la
                #export TF_LOG=TRACE
                ./terraform plan -input=false -no-color
                export TF_LOG=
                ./terraform apply -auto-approve -input=false -no-color
                /bin/rm -rf  .kube/config
                clus_name=\$(./terraform output -json | jq -S -r '.cluster_name.value')
                ./aws eks update-kubeconfig --name \$clus_name
                export PATH=\$(pwd):\$PATH
                ./kubectl get nodes
                ./kubectl apply -f sa_aws_node.yaml
                ./kubectl rollout restart -n kube-system daemonset.apps/aws-node

                """
            }
        }
       stage('destroy') {
            steps {
                sh 'destroy "Apply: $(date +%F-%H:%M:%S)"'
                sh """./terraform destroy -auto-approve -input=false -no-color
                """
            }
        }
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