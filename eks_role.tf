### role to run EKS
resource "aws_iam_role" "eks" {
	name_prefix        = "${var.tags["project"]}_eks_clus"
	assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
	description	= "To run EKS cluster"
	tags  = var.tags
	
}

# maybe common policies will be enough
#data "template_file" "eks_role_policy" {
#  template = file("eks_role.json")
#  #vars = {
#  #  project     = local.project
#  #  account     = data.aws_caller_identity.identity.account_id
#  #}
#}
#
#
#resource "aws_iam_policy" "this" {
#  name = "${var.tags["project"]}_eks_clus"
#  policy = data.template_file.eks_role_policy.rendered
#}
#
#resource "aws_iam_role_policy_attachment" "eks_role" {
#  role       = aws_iam_role.eks.name
#  policy_arn = aws_iam_policy.eks_role_policy.arn
#}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

### /role to run EKS