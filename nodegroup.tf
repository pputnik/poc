resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-ng"
  node_role_arn   = "arn:aws:iam::464194041274:role/jenkins" #aws_iam_role.eks_node.arn
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
    #aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    #aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    #aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly
  ]

  tags = merge(var.tags, {
      Name      = "${var.cluster_name}_node"
  })
}
