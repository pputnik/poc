variable "cidr" {
  default = "10.1.0.0/16"
}

variable "myTuple" {
  type = tuple([string, number, string])
  default = ["qqq", 2, "ddd"]
}

variable "myObj" {
  type = object({
    name = string,
    port = number
  })
  default = {
    name = "http",
    port = 80
  }
}
variable "enabled" {
  type = bool
  default = true
}

variable "ports" {
  type = list(number)
  default = [22, 23, 34]
}

#variable "from_input" {
#  type = number
#  description = "input number here"
#}

variable "region" {
  default = "eu-west-1"
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


