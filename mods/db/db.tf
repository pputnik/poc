variable "name" {
  type = string
}

variable "tags" {
  type = map(string)
}

resource "aws_vpc" "example" {
  cidr_block = "10.1.0.0/16"
  tags       = merge(var.tags, {
    Name = var.name
  })
}

output "tags_all" {
  value = aws_vpc.example.tags_all
}