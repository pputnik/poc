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

resource "random_password" "random" {
  length           = 16
  special          = true
  min_special      = 5
  override_special = "/@%$"
}

resource "aws_security_group" "web" {
  #vpc_id = aws_vpc.example.id
  name = "webSG"
  dynamic "ingress" {
    iterator = port
    for_each = var.ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata_example.sh")
}

resource "aws_instance" "web2" {
  count         = var.create_ec2
  ami           = "ami-065793e81b1869261"
  instance_type = "t2.micro"
  #user_data = data.template_file.user_data.rendered
  #user_data = file("${path.module}/userdata_example.sh") #static template
  user_data     = templatefile("${path.module}/userdata_example.sh.tpl", {
    str_name   = "myName"
    list_names = ["ln1", "ln2"]
  })
  #lifecycle {
  #  create_before_destroy = true
  #}
  user_data_replace_on_change = true

  #  user_data = <<EOF
  ##!/bin/bash
  #
  #sed -i 's/^.* ssh-rsa /ssh-rsa /' /root/.ssh/authorized_keys
  #sed -i 's/PermitRootLogin forced-commands-only/PermitRootLogin yes/' /etc/ssh/sshd_config
  #service ssh restartq
  #
  #inst_id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  #echo inst_id $inst_id
  #echo -n $inst_id > /var/local/inst_id
  #
  #yum install -y httpd
  #echo "$inst_id inline userdata" > /var/www/html/index.html
  #
  #systemctl start httpd.service
  #
  #EOF
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name               = "Alex-irl"

  provisioner "local-exec" {
    command = "echo private_ip=${join(", ", aws_instance.web2[*].private_ip)}"
  }

  provisioner "remote-exec" {
    inline = [
      "cat /etc/os-release",
      "ls -l /home",
      "hostname"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file("../.ssh/Alex-irl")
    }
  }
  tags = merge(local.tags, {
    Name = "itFr4omTF"
  })
}

resource "aws_instance" "web3" {
  ami           = "ami-065793e81b1869261"
  instance_type = "t2.micro"
  tags          = merge(local.tags, {
    Name = "itFr4omTF"
  })
  dynamic "ebs_block_device" {
    for_each = var.project == "prod" ? [1] : []
    content {
      device_name = "/dev/bla"
      volume_size = 8
    }
  }

}

#resource "aws_secretsmanager_secret" "supersecret" {
#  name        = "example"
#  description = "${var.project}-supsec-${terraform.workspace}"
#}
#
#resource "aws_secretsmanager_secret_version" "supsecver" {
#  secret_id     = aws_secretsmanager_secret.supersecret.id
#  secret_string = jsonencode(local.tags)
#}


output "def_out" {
  #value = data.aws_security_groups.test
  value = null_resource.cmd1.id
}