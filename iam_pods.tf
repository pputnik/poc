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