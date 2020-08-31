### Backend and provider config for reference
terraform {
  required_version = "~> 0.12.12"
}

provider "aws" {
  /*assume_role {
    role_arn     = var.assume_role_arn
    session_name = "EKS_deployment_session_${var.tags["environment"]}"
  }*/
  region  = var.region
  version = "~> 3.4"
}

terraform {
  backend "s3" {
    bucket  = "com.dodax.infrastructure.terraform.testing"  # at aws.infrastructure acc
    key     = "Alex-test"
    encrypt = "true"
    region  = "eu-central-1"
    # role in bucket and DDB acc (at aws.infrastructure), will be assumed by TF executor role
    role_arn       = "arn:aws:iam::609350192073:role/jenkins_executor"

    # You can use a single DynamoDB table to control the locking for the state file for all of the accounts
    dynamodb_table = "tf-remote-state-lock"
  }
}