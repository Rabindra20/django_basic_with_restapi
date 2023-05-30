output "cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_arn" {
  value = aws_eks_cluster.eks.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_role_name" {
  value = aws_iam_role.eks_role.name
}