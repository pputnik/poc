### Backend and provider config for reference
terraform {
  required_version = "~> 0.12.29"
  experiments      = [variable_validation]
}

provider "aws" {
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "eks_${local.environment}"
  }
  region  = var.region
  version = "~> 3.3"
}

terraform {
  backend "s3" {
    bucket  = "com.dodax.infrastructure.terraform.testing" # at aws.infrastructure acc
    key     = "alex_poc"
    encrypt = "true"
    region  = "eu-central-1"
    # role in bucket and DDB acc (at aws.infrastructure), will be assumed by TF executor role
    role_arn = "arn:aws:iam::609350192073:role/jenkins_executor"
    # profile = "Infra-Prod"
    # You can use a single DynamoDB table to control the locking for the state file for all of the accounts
    dynamodb_table = "tf-remote-state-lock"
  }
}
