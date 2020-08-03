### Service account role - pod1, access to s3
data "template_file" "pod1_policy" {
  template = file("pod1_iam.json")
}

resource "aws_iam_policy" "pod1_policy" {
  name = "${var.cluster_name}-pod1-pol"
  policy = data.template_file.pod1_policy.rendered
}

data "template_file" "pod1_assume_policy" {
  template = file("oidc_assume_role_policy.json")
  vars = {
    OIDC_ARN  = aws_iam_openid_connect_provider.cluster.arn
    OIDC_URL  = replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")
    NAMESPACE = "s3-managers"
    SA_NAME   = "s3-managers-sa"
  }
}

resource "aws_iam_role" "pod1" {
  name = "eks-pod1"
  assume_role_policy = data.template_file.pod1_assume_policy.rendered
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "pod1_policy" {
  policy_arn = aws_iam_policy.pod1_policy.arn
  role       = aws_iam_role.pod1.name
}

resource "aws_iam_role_policy_attachment" "pod1_policy_CNI" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.pod1.name
}
