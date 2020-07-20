#------------------------------------------#
# Route-Table to internet access
#------------------------------------------#

resource "aws_route_table" "internet_access" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name      = "Route Table Internet Access"
    Terraform = "true"
  }
}

resource "aws_route" "public-to-igw" {
  route_table_id         = "${aws_route_table.internet_access.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_internet_gateway.igw", "aws_route_table.internet_access"]
}

#------------------------------------------#
# Private Route-Table 1a
#------------------------------------------#

resource "aws_route_table" "private_route_table-az-a" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name      = "Route Table Private eu-central-1a"
    Terraform = "true"
  }
}

resource "aws_route" "private_route-az-a" {
  count                  = "${var.ENVIRONMENT == "testing" ? 0 : 1}"
  route_table_id         = "${aws_route_table.private_route_table-az-a.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-az-a[0].id

  #  depends_on             = ["aws_internet_gateway.igw", "aws_route_table.public"]
}

#------------------------------------------#
# Private Route-Table 1b
#------------------------------------------#

resource "aws_route_table" "private_route_table-az-b" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name      = "Route Table Private eu-central-1b"
    Terraform = "true"
  }
}

resource "aws_route" "private_route-az-b" {
  route_table_id         = "${aws_route_table.private_route_table-az-b.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat-az-b.id}"
}

#------------------------------------------#
# Private Route-Table 1c
#------------------------------------------#

resource "aws_route_table" "private_route_table-az-c" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name      = "Route Table Private eu-central-1c"
    Terraform = "true"
  }
}

resource "aws_route" "private_route-az-c" {
  count                  = "${var.ENVIRONMENT == "testing" ? 0 : 1}"
  route_table_id         = aws_route_table.private_route_table-az-c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-az-c[0].id
}

#------------------------------------------#
# Route-Table Association
#------------------------------------------#

resource "aws_route_table_association" "public-az-a" {
  subnet_id      = "${aws_subnet.public-az-a.id}"
  route_table_id = "${aws_route_table.internet_access.id}"
}

resource "aws_route_table_association" "public-az-b" {
  subnet_id      = "${aws_subnet.public-az-b.id}"
  route_table_id = "${aws_route_table.internet_access.id}"
}

resource "aws_route_table_association" "public-az-c" {
  subnet_id      = "${aws_subnet.public-az-c.id}"
  route_table_id = "${aws_route_table.internet_access.id}"
}

resource "aws_route_table_association" "private-az-a" {
  subnet_id      = "${aws_subnet.private-az-a.id}"
  route_table_id = "${aws_route_table.private_route_table-az-a.id}"
}

resource "aws_vpc_endpoint_route_table_association" "private-az-a-s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.private_route_table-az-a.id}"
}

resource "aws_route_table_association" "private-az-b" {
  subnet_id      = "${aws_subnet.private-az-b.id}"
  route_table_id = "${aws_route_table.private_route_table-az-b.id}"
}

resource "aws_vpc_endpoint_route_table_association" "private-az-b-s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.private_route_table-az-b.id}"
}

resource "aws_route_table_association" "private-az-c" {
  subnet_id      = "${aws_subnet.private-az-c.id}"
  route_table_id = "${aws_route_table.private_route_table-az-c.id}"
}

resource "aws_vpc_endpoint_route_table_association" "private-az-c-s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.private_route_table-az-c.id}"
}

#------------------------------------------#
# Route-Table Association Database
#------------------------------------------#

resource "aws_route_table_association" "databases-az-a" {
  subnet_id      = "${aws_subnet.databases-az-a.id}"
  route_table_id = "${aws_route_table.private_route_table-az-a.id}"
}

resource "aws_route_table_association" "databases-az-b" {
  subnet_id      = "${aws_subnet.databases-az-b.id}"
  route_table_id = "${aws_route_table.private_route_table-az-b.id}"
}

resource "aws_route_table_association" "databases-az-c" {
  subnet_id      = "${aws_subnet.databases-az-c.id}"
  route_table_id = "${aws_route_table.private_route_table-az-c.id}"
}
