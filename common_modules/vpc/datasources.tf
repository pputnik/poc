data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = "com.dodax.infrastructure.terraform.${var.ENVIRONMENT}"
    key    = "infrastructure-vpc/terraform.tfstate"
    region = "eu-central-1"
  }
}
