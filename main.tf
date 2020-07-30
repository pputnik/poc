resource "aws_security_group" "this" {
  name_prefix = "allow_tls"
  description = "Allow TLS inbound traffic"
  //vpc_id      = module.vpc.vpc-id
  vpc_id      = var.vpc_id

  ingress {
    description = "internal"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["85.128.77.0/24"]
    description = "ssh for Warsaw 360CL office"
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
	//name = var.cluster_name
	name = var.cluster_name
	enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
	role_arn                  = aws_iam_role.eks.arn
	version                   = var.k8s_version
	vpc_config {
		subnet_ids              = flatten([var.subnet-public-az-a-id, var.subnet-private-az-a-id])
		security_group_ids      = [aws_security_group.this.id]
		endpoint_private_access = "true"
		endpoint_public_access  = "true"
	}
    tags = merge(var.tags, {
      "test"      = "1"
    })
}

### OIDC config
data "aws_region" "current" {}

# Fetch OIDC provider thumbprint for root CA
data "external" "thumbprint" {
  depends_on = [ aws_eks_cluster.this ]
  program = ["./oidc-thumbprint.sh", data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  //thumbprint_list = concat([data.external.thumbprint.result.thumbprint], var.oidc_thumbprint_list)
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.this.identity.0.oidc.0.issuer
}
