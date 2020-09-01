resource "aws_db_instance" "this" {
  allocated_storage                   = 20
  apply_immediately                   = true
  auto_minor_version_upgrade          = true
  backup_retention_period             = 1
  storage_type                        = "gp2"
  engine                              = "mysql"
  engine_version                      = "5.7"
  instance_class                      = "db.t2.micro"
  multi_az                            = false
  iam_database_authentication_enabled = true
  name                                = var.project
  username                            = "foo"
  password                            = "foo123bar567baz"
  db_subnet_group_name                = aws_db_subnet_group.default.name
}

resource "aws_db_subnet_group" "default" {
  name       = var.project
  subnet_ids = ["subnet-099b892eba3ec327c"]

  tags = var.tags
}

resource "aws_db_security_group" "this" {
  name = "rds_sg"

  ingress {
    cidr = "10.0.0.0/24"
  }
  tags = var.tags
}
