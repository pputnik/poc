module "vpc"{
	source = "git@github.com:dodax/terraform-aws-vpc?ref=1.0.0"
	DEFAULT_REGION = var.region
	ENVIRONMENT = var.tags["environment"]
	LB_SSL_DOMAIN              = "eks-test.local"
	PROJECTNAME                = "eks-test"
	VPC_CIDR                   = "10.31.0.0/16"
	SUBNET_CIDR_PUBLIC_AZ-a    = "10.31.1.0/24"
	SUBNET_CIDR_PUBLIC_AZ-b    = "10.31.2.0/24"
	SUBNET_CIDR_PUBLIC_AZ-c    = "10.31.3.0/24"
	SUBNET_CIDR_PRIVATE_AZ-a   = "10.31.4.0/24"
	SUBNET_CIDR_PRIVATE_AZ-b   = "10.31.5.0/24"
	SUBNET_CIDR_PRIVATE_AZ-c   = "10.31.6.0/24"
	SUBNET_CIDR_DATABASES_AZ-a = "10.31.7.0/24"
	SUBNET_CIDR_DATABASES_AZ-b = "10.31.8.0/24"
	SUBNET_CIDR_DATABASES_AZ-c = "10.31.9.0/24"
	
	assume_role_arn_infra = var.assume_role_arn_infra
	tags  = var.tags
}

resource "aws_security_group" "this" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc-id

  ingress {
    description = "internal"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({
	Name = "allow_internal"
  }, var.tags)
}

### EKS cluster config
resource "aws_eks_cluster" "this" {
	name = var.cluster_name
	depends_on = [ aws_cloudwatch_log_group.this ]
	enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
	role_arn                  = aws_iam_role.eks.arn
	version                   = "1.16"
	vpc_config {
		subnet_ids              = flatten([module.vpc.subnet-public-az-a-id, module.vpc.subnet-private-az-a-id])
		security_group_ids      = [aws_security_group.this.id]
		endpoint_private_access = "true"
		endpoint_public_access  = "true"
	}
}

resource "aws_cloudwatch_log_group" "this" {
  name_prefix	= "/aws/eks/${var.cluster_name}"
  retention_in_days = 1
	tags  = var.tags
}

### OIDC config
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = []
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}