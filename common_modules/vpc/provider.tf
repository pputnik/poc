provider "aws" {
	alias = "infrastructure"
  assume_role {
    role_arn     = var.assume_role_arn_infra
    session_name = "EKS_deployment_session_${var.tags["environment"]}"
  }
  region     = var.DEFAULT_REGION
}