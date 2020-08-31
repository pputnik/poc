locals {
  environment = var.workspace_to_environment[terraform.workspace]
}

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
  name                                = "mydb"
  username                            = "foo"
  password                            = "foobarbaz"
}

resource "aws_db_security_group" "this" {
  name = "rds_sg"

  ingress {
    cidr = "10.0.0.0/24"
  }
}

resource "aws_lambda_function" "this" {
  function_name    = var.project
  handler          = "index.handler"
  role             = aws_iam_role.this.arn
  runtime          = "python3.7"
  memory_size      = 128
  timeout          = 3
  publish          = true
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

}

data "null_data_source" "file" {
  inputs = {
    filename = "test.py"
  }
}

data "null_data_source" "archive" {
  inputs = {
    filename = "test.zip"
  }
}

data "archive_file" "this" {
  type        = "zip"
  source_file = data.null_data_source.file.outputs.filename
  output_path = data.null_data_source.archive.outputs.filename
}

resource "aws_iam_role" "this" {
  name               = "content-cache-image-provider"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.this.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "s3:*",
    ]
    resources = "*"
  }
}

resource "aws_iam_policy" "this" {
  name   = "lambda-iam-rds"
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_iam_role_policy_attachment" "lir" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}