### Backend and provider config for reference
terraform {
  required_version = "~> 0.12.29"
}

provider "aws" {
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "${var.tags["project"]}-${terraform.workspace}"
  }
  region  = var.region
  version = "~> 3.4"
}

provider "aws" {
  alias  = "infrastructure"
  region = var.region

  assume_role {
    role_arn     = "arn:aws:iam::609350192073:role/jenkins_executor" # infrastructure
    session_name = "${var.tags["project"]}-${terraform.workspace}"
  }
}

terraform {
  backend "s3" {
    bucket  = "com.dodax.infrastructure.terraform.testing" # at aws.infrastructure acc
    key     = "alex_poc"
    encrypt = "true"
    region  = "eu-central-1"
    role_arn = "arn:aws:iam::609350192073:role/jenkins_executor"
    # You can use a single DynamoDB table to control the locking for the state file for all of the accounts
    dynamodb_table = "tf-remote-state-lock"
  }
}
