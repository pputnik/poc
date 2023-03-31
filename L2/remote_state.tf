terraform {
  backend "s3" {
    region         = "eu-west-1"  # required for automation, or tf will ask
    session_name   = "tf-test-alex"
    bucket         = "tf-remote-state-636834150364"
    key            = "web/terraform.tfstate"
    dynamodb_table = "tf-remote-state-lock"
    # aws dynamodb create-table --table-name tf-remote-state-lock --key-schema  AttributeName=LockID,KeyType=HASH --attribute-definitions AttributeName=LockID,AttributeType=S --billing-mode PAY_PER_REQUEST
  }
}

data "terraform_remote_state" "net" {
  backend = "s3"
  config {
    region = "eu-west-1"
    bucket = "tf-remote-state-636834150364"
    key    = "net/terraform.tfstate"  # from another template, where we want to read data from
  }
}

resource "aws_instance" "web_server" {
  # priv_subnets must be declared of that stack output (here - list)
  subnet_id = data.terraform_remote_state.net.outputs.priv_subnets[0]
}