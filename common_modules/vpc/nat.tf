#------------------------------------------#
# NAT-Gateway
#------------------------------------------#

resource "aws_nat_gateway" "nat-az-a" {
  count         = "${var.ENVIRONMENT == "testing" ? 0 : 1}"
  allocation_id = aws_eip.igw_eip-az-a[0].id
  subnet_id     = "${aws_subnet.public-az-a.id}"
  depends_on    = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "nat-az-b" {
  allocation_id = "${aws_eip.igw_eip-az-b.id}"
  subnet_id     = "${aws_subnet.public-az-b.id}"
  depends_on    = ["aws_internet_gateway.igw"]
}

resource "aws_nat_gateway" "nat-az-c" {
  count         = "${var.ENVIRONMENT == "testing" ? 0 : 1}"
  allocation_id = aws_eip.igw_eip-az-c[0].id
  subnet_id     = "${aws_subnet.public-az-c.id}"
  depends_on    = ["aws_internet_gateway.igw"]
}

output "nat-gw-az-a-public-ip" {
  value = "${element(concat(aws_nat_gateway.nat-az-a.*.public_ip, list("")), 0)}"
}

output "nat-gw-az-b-public-ip" {
  value = "${element(concat(aws_nat_gateway.nat-az-b.*.public_ip, list("")), 0)}"
}

output "nat-gw-az-c-public-ip" {
  value = "${element(concat(aws_nat_gateway.nat-az-c.*.public_ip, list("")), 0)}"
}
