terraform {
  backend "local" {
  }
}
variable "region" {
  default = "eu-west-1"
}

provider "aws" {
  region = var.region
}

variable "param_name" {
  type = string
}

variable "param_val" {
  type = string
}

module "my_param" {
  source = "./modules"
  name   = "${var.param_name}-${terraform.workspace}"
  value  = var.param_val

}

output "arn" {
  value = module.my_param.arn

}