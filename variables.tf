variable "cluster_name" {
  default = "Alex_test"
}

variable "k8s_version" {
  default = "1.17"
}
variable "ssh_key" {
  default = "build-temp-bastion"
}

variable "vpc_id" {
  default = "vpc-5379fd3b"
}

variable "subnet-public-az-a-id" {
  default = "subnet-54fabd3c"
}

variable "subnet-private-az-a-id" {
  default = "subnet-5e890624"
}

variable "assume_role_arn" {
  default = "arn:aws:iam::861836199847:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_SysAdmin-Test-Env_8abb7ca94235bbe7"
}

variable "assume_role_arn_infra" {
  default = "arn:aws:iam::609350192073:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_ViewOnlyAccess_3b7be628c1ee9b1c"
}

variable "region" {
  default = "eu-central-1"
}

variable "environment" {
  default = "testing"
}

variable "tags" {
  type    = map(string)
  default = {
    environment = "testing"
    project	    = "eks_poc"
    Terraform   = "true"
  }
}
