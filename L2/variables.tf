variable "create_ec2" { default = 1 }

variable "cidr" {
  default = "10.1.0.0/16"
}

variable "myTuple" {
  type    = tuple([string, number, string])
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
  type    = bool
  default = true
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443]
}

#variable "from_input" {
#  type = number
#  description = "input number here"
#}

variable "ami" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
  nullable    = false
  default     = "ami-werwe"
  validation {
    condition     = length(var.ami) > 4 && substr(var.ami, 0, 4) == "ami-"
    error_message = "The 'ami' value must be a valid AMI id, starting with 'ami-'."
  }
}

variable "region" {
  default = "eu-west-1"
}

variable "project" {
  default = "poc"
}

variable "tags" {
  type    = map(string)
  default = {
    project   = "eks_poc"
    Terraform = "true"
  }
}

variable "workspace_to_environment" {
  description = "Map linking a given workspace to an environment"
  type        = map(string)
  default     = {
    test = "testing"
    prod = "production"
  }
}


locals {
  tags = {
    owner = "me"
  }
}