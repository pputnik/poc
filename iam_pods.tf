### node role
data "template_file" "node_role_policy" {
  template = file("oidc_assume_role_policy.json")
  vars = {
    OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn
    OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")
    NAMESPACE = "kube-system"
    SA_NAME   = "aws-node"
  }
}

resource "aws_iam_role" "aws_node" {
  name = "${var.cluster_name}-aws-node"
  //assume_role_policy =  templatefile("oidc_assume_role_policy.json", { OIDC_ARN = aws_iam_openid_connect_provider.cluster.arn, OIDC_URL = replace(aws_iam_openid_connect_provider.cluster.url, "https://", ""), NAMESPACE = "kube-system", SA_NAME = "aws-node" })
  assume_role_policy =  data.template_file.node_role_policy.rendered

  tags = merge(var.tags, {
      "ServiceAccountName"      = "aws-node"
      "ServiceAccountNameSpace" = "kube-system"
  })
  depends_on = [aws_iam_openid_connect_provider.cluster]
}

resource "aws_iam_role_policy_attachment" "aws_node" {
  role       = aws_iam_role.aws_node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"depends_on = [aws_iam_role.aws_node]
}

### role to run POD1
/*resource "aws_iam_role" "pod1" {
	name_prefix        = "${var.tags["project"]}_pod1"
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
	description	= "To run pod1 on EKS cluster"
	tags  = var.tags
	
}

data "template_file" "pod1_policy" {
  template = file("iam_pods.json")
  vars = {
    action     = "ec2:Describe*"
  }
}

resource "aws_iam_policy" "pod1" {
  name_prefix = "${var.tags["project"]}_pod1"
  policy      = data.template_file.pod1_policy.rendered
}

resource "aws_iam_role_policy_attachment" "pod1_role" {
  role       = aws_iam_role.pod1.name
  policy_arn = aws_iam_policy.pod1.arn
}
*/