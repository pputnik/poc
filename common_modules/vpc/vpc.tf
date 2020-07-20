resource "aws_vpc" "vpc" {
  cidr_block           = "${var.VPC_CIDR}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  enable_classiclink   = "false"

  tags = merge({
    Name      = "vpc"
    Terraform = "true"
  },var.tags)
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.DEFAULT_REGION}.s3"
}

output "vpc-id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc-cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}
