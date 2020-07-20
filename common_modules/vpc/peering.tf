#------------------------------------------#
# Requester's side of the connection
#------------------------------------------#

resource "aws_vpc_peering_connection" "peer-infrastructure" {
  vpc_id        = aws_vpc.vpc.id
  peer_vpc_id   = data.terraform_remote_state.infrastructure.vpc-id
  peer_owner_id = data.terraform_remote_state.infrastructure.account-id

  #  auto_accept   = false

  tags = merge({
    Name      = "Peering Connection ${var.PROJECTNAME}-Infrastructure",
    Terraform = "true"
  },var.tags)
}

#------------------------------------------#
# Accepter's side of the connection
#------------------------------------------#

resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.infrastructure"
  vpc_peering_connection_id = aws_vpc_peering_connection.peer-infrastructure.id
  auto_accept               = true

  tags = merge({
    Name      = "Peering Connection ${var.PROJECTNAME}",
    Terraform = "true"
  },var.tags)
}

output "pcx-infrastructure" {
  value = "${aws_vpc_peering_connection.peer-infrastructure.id}"
}
