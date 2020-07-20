#------------------------------------------#
# Elastic-IP
#------------------------------------------#

resource "aws_eip" "igw_eip-az-a" {
  count      = "${var.ENVIRONMENT == "testing" ? 0 : 1}"
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_eip" "igw_eip-az-b" {
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}

resource "aws_eip" "igw_eip-az-c" {
  count      = "${var.ENVIRONMENT == "testing" ? 0 : 1}"
  vpc        = true
  depends_on = ["aws_internet_gateway.igw"]
}
