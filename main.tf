terraform {
#  backend "remote" {
#    organization = "partner-nordcloud-nfr"
#    workspaces {
#      name = "al-test"
#    }
#  }
  backend "s3" {
    #role_arn             = "arn:aws:iam::576614186076:role/backend"
    region               = "eu-west-1"  # required for automation, or tf will ask
    session_name         = "tf-test-alex"
    bucket               = "tf-remote-state-636834150364"
    workspace_key_prefix = "poc"
    key                  = "terraform.tfstate"
    dynamodb_table       = "tf-remote-state-lock"
    # aws dynamodb create-table --table-name tf-remote-state-lock --key-schema  AttributeName=LockID,KeyType=HASH --attribute-definitions AttributeName=LockID,AttributeType=S --billing-mode PAY_PER_REQUEST
  }

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
data "aws_caller_identity" "current" {}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      tf = true
    }
  }
}

resource "aws_instance" "web2" {
  ami           = "ami-065793e81b1869261"
  instance_type = "t2.micro"
  tags          = merge(local.tags, {
    Name = "itFr4omTF"
  })
  dynamic "ebs_block_device" {
    for_each = local.tags["stage"] == "prod" ? [1] : []
    content {
      device_name = "/dev/bla"
      volume_size = 8
    }
  }

}


output "def_out" {
  value = lookup(var.ami_ubuntu_trusty, var.region, "ERR")
}

output "is_prod" {
  value = local.tags["stage"] == "prod" ? "yep" : "nope"
}


