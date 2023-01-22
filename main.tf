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

provider "aws" {
  region  = var.region
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.cidr

}

