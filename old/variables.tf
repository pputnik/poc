variable "region" {
  default = "eu-central-1"
}

variable "project" {
  default = "lir" #lambda-iam-rds
}

variable "tags" {
  type = map(string)
  default = {
    project   = "eks_poc"
    Terraform = "true"
  }
}

variable "workspace_to_environment" {
  description = "Map linking a given workspace to an environment"
  type        = map(string)
  default = {
    test = "testing"
    prod = "production"
  }
}

variable "assume_role_arn" { # infra-test
  default = "arn:aws:iam::313829517975:role/jenkins_executor"
}

