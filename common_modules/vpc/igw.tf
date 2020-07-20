#------------------------------------------#
# Internet Gateway
#------------------------------------------#

resource "aws_internet_gateway" "igw" {
  provider = "aws.infrastructure"
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "Internet Gateway"
  },var.tags)
}
