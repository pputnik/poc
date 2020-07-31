resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = flatten([var.subnet-public-az-a-id, var.subnet-private-az-a-id])
  instance_types  = ["t3a.small"]
  //ami_type
  //disk_size

  remote_access {
    ec2_ssh_key = var.ssh_key
    source_security_group_ids = [aws_security_group.this.id]
  }

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.serv_acc_policy,
    aws_iam_role_policy_attachment.serv_acc_policy_CNI
  ]

  tags = merge(var.tags, {
      Name      = "${var.cluster_name}_node"
  })
}

### node group role
resource "aws_iam_role" "eks_node" {
  name = "eks-node-group"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  force_detach_policies = true

}

data "template_file" "eks_node_extra_policy" {
  template = file("iam_service_acc.json")
  vars = {
    action = "[\"sts:AssumeRoleWithWebIdentity\", \"ec2:DescribeNetworkInterfaces\"]"
  }
}

resource "aws_iam_policy" "eks_node_extra_policy_policy" {
  name = "${var.cluster_name}-eks_node_extra"
  policy = data.template_file.eks_node_extra_policy.rendered
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}