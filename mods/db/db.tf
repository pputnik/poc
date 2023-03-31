variable "name" {
  type = string
}

resource "aws_vpc" "example" {
  cidr_block = "10.1.0.0/16"
  tags       = {
    Name = var.name
  }
  #  tags = merge(local.tags, {
  #    Name = var.name
  #  })
}

output "tags_all" {
  value = aws_vpc.example.tags_all
}