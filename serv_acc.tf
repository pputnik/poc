### Service account role
data "template_file" "serv_acc_policy" {
  template = file("iam_service_acc.json")
  vars = {
    action = "[\"s3:*\",\"sts:AssumeRoleWithWebIdentity\", \"ec2:DescribeNetworkInterfaces\"]"
  }
}

resource "aws_iam_policy" "serv_acc_policy" {
  name = "${var.cluster_name}-srev-acc-pol"
  policy = data.template_file.serv_acc_policy.rendered
}

data "template_file" "serv_acc_assume_policy" {
  template = file("oidc_assume_role_policy.json")
  vars = {
    OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn
    OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")
    NAMESPACE = "kube-system"
    SA_NAME   = "aws-node"
  }
}

resource "aws_iam_role" "serv_acc" {
  name = "eks-service-account"
  assume_role_policy = data.template_file.serv_acc_assume_policy.rendered
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "serv_acc_policy" {
  policy_arn = aws_iam_policy.serv_acc_policy.arn
  role       = aws_iam_role.serv_acc.name
}

resource "aws_iam_role_policy_attachment" "serv_acc_policy_CNI" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.serv_acc.name
}
