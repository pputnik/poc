resource "aws_db_instance" "this" {
  allocated_storage          = 20
  auto_minor_version_upgrade = true
  storage_type               = "gp2"
  engine                     = "mysql"
  engine_version             = "5.7"
  instance_class             = "db.t2.micro"
  multi_az                   = false
  name                       = var.project
  username                   = "foo"
  password                   = "foo123bar567baz"
  tags = var.tags

  apply_immediately        = true
  backup_retention_period  = 0
  delete_automated_backups = true
  skip_final_snapshot      = true

  iam_database_authentication_enabled = true
  db_subnet_group_name                = aws_db_subnet_group.default.name
  vpc_security_group_ids              = [aws_security_group.allow_mysql.id]
}


resource "aws_db_subnet_group" "default" {
  name       = var.project
  subnet_ids = ["subnet-099b892eba3ec327c", "subnet-0a134a94188b08f24"]

  tags = var.tags
}


resource "aws_security_group" "allow_mysql" {
  name   = "allow_mysql"
  vpc_id = "vpc-0ad836f1b7bb4b621"

  ingress {
    description = "TLS from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

