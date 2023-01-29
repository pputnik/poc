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
    }
  }
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = var.cidr

  tags = {
    projtag = var.tags["project"]
    myregion = data.aws_region.current.name
    from_input = var.from_input

  }
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.example.id
  name = "webSG"
  dynamic "ingress" {
    iterator = port
    for_each = var.ports
    content {
      from_port = port.value
      to_port = port.value
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  depends_on = ["aws_vpc.example"]
}

output "vpc_id" {
  value = aws_vpc.example.id
}

output "from_input_to_out" {
  value = var.from_input
}