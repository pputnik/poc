data "aws_caller_identity" "current" {}

locals {
  environment = var.workspace_to_environment["test"]
  acc_id      = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source       = "git@github.com:dodax/terraform-aws-vpc?ref=workspaces"
  environment  = terraform.workspace
  project_name = var.tags["project"]

  vpc_cidr = "${var.cidr_head}.128.0/17"
  subnet_cidr_public = {
    az_a = "${var.cidr_head}.128.0/24"
    az_b = "${var.cidr_head}.129.0/24"
    az_c = "${var.cidr_head}.130.0/24"
  }
  subnet_cidr_private = {
    az_a = "${var.cidr_head}.144.0/24"
    az_b = "${var.cidr_head}.145.0/24"
    az_c = "${var.cidr_head}.146.0/24"
  }
  subnet_databases_creation = false

  tags = var.tags
}