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
  version = "~> 2.70"
}

