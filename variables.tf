variable "cidr_head" {
  description = "first two octets ov VPC CIDR range like 10.33 withOUT dot"
}

variable "region" {
  default = "eu-central-1"
}

# variable "project" {  see var.tags["project"]

variable "tags" {
  type = map(string)
  default = {
    project   = "poc"
    Terraform = "true"
  }
}

variable "workspace_to_environment" {
  description = "Map linking a given workspace to an environment"
  type        = map(string)
  default = {
    alex = "testing"
    test = "testing"
    prod = "production"
  }
}

