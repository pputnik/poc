variable "cluster_name" {
  default = "Alex_test"
}

variable "vpc_id" {
  default = "vpc-0287de7d6e2df9308"
}

variable "subnet-public-az-a-id" {
  default = "subnet-07f78926aae0161c9"
}

variable "subnet-private-az-a-id" {
  default = "subnet-0009f1c693692f092"
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

variable "envronment" {
  default = "testing"
}

variable "tags" {
  type    = map(string)
  default = {
		environment= "testing"
		project	= "eks_poc"
	}
}
