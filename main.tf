data "aws_caller_identity" "current" {}

locals {
  environment = var.workspace_to_environment["test"]
  acc_id      = data.aws_caller_identity.current.account_id
}

data "external" "dbuser" {
  depends_on = [aws_db_instance.this]
  program    = ["./adduser.sh", aws_db_instance.this.name]
}

resource "aws_lambda_function" "this" {
  depends_on = [data.external.dbuser]
  function_name    = var.project
  handler          = "index.handler"
  role             = aws_iam_role.this.arn
  runtime          = "python3.7"
  memory_size      = 128
  timeout          = 3
  publish          = true
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

   vpc_config {
    subnet_ids         = ["subnet-fa83afb0", "subnet-fbf2b593"]
    security_group_ids = [aws_security_group.allow_mysql.id]
  }

  environment {
    variables = {
      DB_HOST = aws_db_instance.this.address
      DB_NAME = aws_db_instance.this.name
      DB_USER = "lambda-user"
    }
  }
  tags = var.tags
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

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql"
  vpc_id      = "vpc-0973f761"

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
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    actions = [
      "rds-db:connect",
    ]
    resources = [
      "arn:aws:rds:${var.region}:${local.acc_id}:dbuser:myworld/username"
    ]
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
