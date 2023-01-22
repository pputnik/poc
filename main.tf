terraform {
  required_version = "~> 1.3"
  #experiments      = [variable_validation]
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.50"
    }
  }
}

data "aws_region" "current" {}

provider "aws" {
  region  = var.region
  default_tags {
    tags = {
      tf = true
      myregion = data.aws_region.current.name
    }
  }
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.cidr

  tags = {
    port22 = var.mylist[0]
    projtag = var.tags["project"]

  }
}

