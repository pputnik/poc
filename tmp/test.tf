provider "aws" {
	alias = "infrastructure"
  assume_role {
    role_arn     = var.assume_role_arn_infra
    session_name = "EKS_deployment_session_${var.tags["environment"]}"
  }
  region     = var.region
}
terraform {
  required_version = "~> 0.12.12"
}

provider "aws" {
  assume_role {
    role_arn     = var.assume_role_arn
    session_name = "EKS_deployment_session_${var.tags["environment"]}"
  }
  region  = var.region
  version = "~> 2.28.1"
}

variable "assume_role_arn" {
  default = "arn:aws:iam::861836199847:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_SysAdmin-Test-Env_8abb7ca94235bbe7"
}

variable "assume_role_arn_infra" {
  default = "arn:aws:iam::609350192073:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_ViewOnlyAccess_3b7be628c1ee9b1c"
}

variable "cluster_name" {
  default = "Alex_test"
}

variable "region" {
  default = "eu-central-1"
}

variable "envronment" {
  default = "testing"
}




data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = "com.dodax.infrastructure.terraform.${var.envronment}"
    key    = "infrastructure-vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}

output "rs_infra" {
  value = data.terraform_remote_state.infrastructure
}
