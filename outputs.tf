output "eks_cluster_id" {
  value = try(
    aws_eks_cluster.this.*.id
  )
}

output "eks_cluster_arn" {
  value = try(
    aws_eks_cluster.this.*.arn
  )
}

output "eks_cluster_oidc_issuer" {
  value = try(
    aws_eks_cluster.this.*.identity[0].oidc[0].issuer
  )
}

output "eks_addon_id" {
  value = try(
    aws_eks_addon.this.*.id
  )
}

output "eks_addon_arn" {
  value = try(
    aws_eks_addon.this.*.arn
  )
}

output "node_group_id" {
  value = try(
    aws_eks_node_group.this.*.id
  )
}

output "eks_node_group_arn" {
  value = try(
    aws_eks_node_group.this.*.arn
  )
}