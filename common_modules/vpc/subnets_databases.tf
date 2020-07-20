#------------------------------------------#
# Database Subnets
#------------------------------------------#

resource "aws_subnet" "databases-az-a" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.SUBNET_CIDR_DATABASES_AZ-a}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags = merge({
    Name      = "databases-subnet-az-a",
    Terraform = "true"
  },var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "databases-az-b" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.SUBNET_CIDR_DATABASES_AZ-b}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags = merge({
    Name      = "databases-subnet-az-b",
    Terraform = "true"
  },var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "databases-az-c" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${var.SUBNET_CIDR_DATABASES_AZ-c}"
  availability_zone = "${data.aws_availability_zones.available.names[2]}"

  tags = merge({
    Name      = "databases-subnet-az-c",
    Terraform = "true"
  },var.tags)

  lifecycle {
    create_before_destroy = true
  }
}

#------------------------------------------#
# Database Subnet-Group
#------------------------------------------#

resource "aws_db_subnet_group" "rds-subnet-group" {
  ##  provider = "aws.infrastructure"
  name        = "sng-rds"
  description = "Use sn-databases-az-a/-1b for RDS instances"
  subnet_ids  = ["${aws_subnet.databases-az-a.id}", "${aws_subnet.databases-az-b.id}", "${aws_subnet.databases-az-b.id}"]

  tags = merge({
    Name      = "Database subnet group"
    Terraform = "true"
  },var.tags)
}

output "rds-subnet-group" {
  value = "${aws_db_subnet_group.rds-subnet-group.id}"
}

output "subnet-databases-az-a-cidr" {
  value = "${aws_subnet.databases-az-a.cidr_block}"
}

output "subnet-databases-az-a-id" {
  value = "${aws_subnet.databases-az-a.id}"
}

output "subnet-databases-az-b-id" {
  value = "${aws_subnet.databases-az-b.id}"
}

output "subnet-databases-az-b-cidr" {
  value = "${aws_subnet.databases-az-b.cidr_block}"
}

output "subnet-databases-az-c-id" {
  value = "${aws_subnet.databases-az-c.id}"
}

output "subnet-databases-az-c-cidr" {
  value = "${aws_subnet.databases-az-c.cidr_block}"
}
