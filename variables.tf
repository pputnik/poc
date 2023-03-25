variable "ami_ubuntu_trusty" {
  default = {
    eu-west-1 = "ami-01ed4072"
    us-east-1 = "ami-5c207736"
    us-west-1 = "ami-fdf69d9d"
    us-west-2 = "ami-b24856d3"
  }
}

variable "names" {
  type    = list(string)
  default = ["x22", "c80", "v443"]
}


variable "region" {
  default = "eu-west-1"
}

variable "project" {
  default = "poc"
}

locals {
  tags = {
    owner = "me"
    stage = "stag"
  }
}
