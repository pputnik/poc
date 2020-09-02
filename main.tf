data "aws_caller_identity" "current" {}

locals {
  environment = var.workspace_to_environment["test"]
  acc_id      = data.aws_caller_identity.current.account_id
}


data "external" "dbuser" {
  depends_on = [aws_db_instance.this]
  program    = ["./adduser.sh", aws_db_instance.this.address, aws_db_instance.this.username, aws_db_instance.this.password]
}

resource "aws_lambda_function" "this" {
  depends_on       = [data.external.dbuser]
  function_name    = var.project
  handler          = "test.handler"
  role             = aws_iam_role.this.arn
  runtime          = "python3.7"
  memory_size      = 128
  timeout          = 3
  publish          = true
  filename         = data.archive_file.this.output_path
  source_code_hash = data.archive_file.this.output_base64sha256

  vpc_config {
    subnet_ids         = ["subnet-099b892eba3ec327c"]
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

# lambda stuff
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

resource "aws_iam_role_policy_attachment" "lambda-basic" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy_attachment" "lambda-vpc" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions = [ "rds-db:connect" ]
    resources = [ "arn:aws:rds:${var.region}:${local.acc_id}:dbuser:${aws_db_instance.this.id}/lambda-user" ]
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

