variable "assume_role_arn" {
  default = "arn:aws:sts::861836199847:assumed-role/AWSReservedSSO_SysAdmin-Test-Env_8abb7ca94235bbe7"
}

variable "assume_role_arn_infra" {
  default = "arn:aws:sts::609350192073:assumed-role/AWSReservedSSO_ViewOnlyAccess_3b7be628c1ee9b1c"
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

variable "tags" {
  type    = map(string)
  default = {
		environment= "testing"
		project	= "eks_poc"
	}
}
