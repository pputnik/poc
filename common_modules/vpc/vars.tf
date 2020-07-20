#------------------------------------------#
# VPC Variables
#------------------------------------------#

variable "VPC_CIDR" {}
variable "PROJECTNAME" {}
variable "ENVIRONMENT" {}
variable "LB_SSL_DOMAIN" {}

variable "DEFAULT_REGION" {
  description = "Used to set up the S3 VPC endpoint"
  default     = "eu-central-1"
}

#------------------------------------------#
# Public and Private Subnet Variables
#------------------------------------------#

variable "SUBNET_CIDR_PUBLIC_AZ-a" {}
variable "SUBNET_CIDR_PUBLIC_AZ-b" {}
variable "SUBNET_CIDR_PUBLIC_AZ-c" {}

variable "SUBNET_CIDR_PRIVATE_AZ-a" {}
variable "SUBNET_CIDR_PRIVATE_AZ-b" {}
variable "SUBNET_CIDR_PRIVATE_AZ-c" {}

variable "SUBNET_CIDR_DATABASES_AZ-a" {}
variable "SUBNET_CIDR_DATABASES_AZ-b" {}
variable "SUBNET_CIDR_DATABASES_AZ-c" {}

#-----
variable "tags" {
  type    = map(string)
  default = {}
}

variable "assume_role_arn_infra" {}
