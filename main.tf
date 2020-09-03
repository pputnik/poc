data "aws_caller_identity" "current" {}

locals {
  environment = var.workspace_to_environment["test"]
  acc_id      = data.aws_caller_identity.current.account_id
}
