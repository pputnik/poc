output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.this.name
}

/*output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.this.certificate_authority.0.data
}
*/

output "openid_connect_provider_url" {
  value = aws_iam_openid_connect_provider.cluster.url
}

output "tmp" {
  value = data.template_file.serv_acc_policy_2.rendered
}
