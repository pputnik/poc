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

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      tf = true
    }
  }
}

variable "ec2_needed" {
  default = "no"
}
resource "aws_instance" "web3" {
  count         = 3
  ami           = "ami-065793e81b1869261"
  instance_type = "t2.micro"

  tags = merge(local.tags, {
    Name = "itFr4omTF"
  })

}


output "def_out" {
  value = [
    for x in aws_instance.web3 :
    "${x.id} => ${x.private_ip}"
  ]
}

