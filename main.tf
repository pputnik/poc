locals {
  environment = var.workspace_to_environment["test"]
}

variable "project" {
  default = "bug-test"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.35.128.0/17"
  tags       = { "Name" = "${var.project}-Infrastructure" }
}

#------------------------------------------#
# Requester's side of the connection
#------------------------------------------#

resource "aws_vpc_peering_connection" "peer-infrastructure" {
  vpc_id        = aws_vpc.vpc.id
  peer_vpc_id   = "vpc-0973f761"
  peer_owner_id = "313829517975"
  peer_region   = "eu-central-1"
  auto_accept   = true

  tags = { "Name" = "${var.project}-Infrastructure" }
}

#------------------------------------------#
# Accepter's side of the connection
#------------------------------------------#

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = aws.infrastructure

  vpc_peering_connection_id = aws_vpc_peering_connection.peer-infrastructure.id
  auto_accept               = true

  tags = { "Name" = "${var.project}-Infrastructure" }
}