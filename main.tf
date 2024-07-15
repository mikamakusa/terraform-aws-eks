resource "aws_eks_access_entry" "this" {
  count             = length(var.cluster) == 0 ? 0 : length(var.access_entry)
  cluster_name      = try(
    element(aws_eks_cluster.this.*.name, lookup(var.access_entry[count.index], "cluster_id"))
  )
  principal_arn     = try(
    element(aws_iam_role.this.*.arn, lookup(var.access_entry[count.index], "principal_id"))
  )
  kubernetes_groups = lookup(var.access_entry[count.index], "kubernetes_groups")
  tags              = merge(
    var.tags,
    lookup(var.access_entry[count.index], "tags")
  )
  type              = lookup(var.access_entry[count.index], "type")
  user_name         = lookup(var.access_entry[count.index], "user_name")
}

resource "aws_eks_access_policy_association" "this" {
  count         = length(var.cluster) == 0 ? 0 : length(var.access_policy_association)
  policy_arn    = join("/", ["arn:aws:eks::aws:cluster-access-policy", lookup(var.access_policy_association[count.index], "policy_name")])
  cluster_name  = try(
    element(aws_eks_cluster.this.*.name, lookup(var.access_policy_association[count.index], "cluster_id"))
  )
  principal_arn = try(
    element(aws_iam_role.this.*.arn, lookup(var.access_policy_association[count.index], "principal_id"))
  )

  dynamic "access_scope" {
    for_each = lookup(var.access_policy_association[count.index], "access_scope")
    content {
      type       = lookup(access_scope.value, "type")
      namespaces = lookup(access_scope.value, "namespaces")
    }
  }
}

resource "aws_eks_cluster" "this" {
  count                     = length(var.cluster)
  name                      = lookup(var.cluster[count.index], "name")
  role_arn                  = try(
    element(aws_iam_role.this.*.arn, lookup(var.cluster[count.index], "role_id"))
  )
  enabled_cluster_log_types = lookup(var.cluster[count.index], "enabled_cluster_log_types")
  tags                      = merge(
    var.tags,
    lookup(var.cluster[count.index], "tags")
  )
  version                   = lookup(var.cluster[count.index], "version")

  dynamic "vpc_config" {
    for_each = lookup(var.cluster[count.index], "vpc_config")
    content {
      subnet_ids              = [data.aws_subnet.this.id]
      endpoint_private_access = lookup(vpc_config.value, "endpoint_private_access")
      endpoint_public_access  = lookup(vpc_config.value, "endpoint_public_access")
      security_group_ids      = [data.aws_security_group.this.id]
      public_access_cidrs     = lookup(vpc_config.value, "public_access_cidrs")
    }
  }

  dynamic "access_config" {
    for_each = lookup(var.cluster[count.index], "access_config") == null ? [] : ["access_config"]
    content {
      authentication_mode                         = lookup(access_config.value, "authentication_mode")
      bootstrap_cluster_creator_admin_permissions = lookup(access_config.value, "bootstrap_cluster_creator_admin_permissions")
    }
  }

  dynamic "encryption_config" {
    for_each = lookup(var.cluster[count.index], "encryption_config") == null ? [] : ["encryption_config"]
    content {
      resources = lookup(encryption_config.value, "resources")

      dynamic "provider" {
        for_each = lookup(encryption_config.value, "provider")
        content {
          key_arn = data.aws_kms_key.this.arn
        }
      }
    }
  }

  dynamic "kubernetes_network_config" {
    for_each = lookup(var.cluster[count.index], "kubernetes_network_config") == null ? [] : ["kubernetes_network_config"]
    content {
      service_ipv4_cidr = lookup(kubernetes_network_config.value, "service_ipv4_cidr")
      ip_family         = lookup(kubernetes_network_config.value, "ip_family")
    }
  }

  dynamic "outpost_config" {
    for_each = lookup(var.cluster[count.index], "outpost_config") == null ? [] : ["outpost_config"]
    content {
      outpost_arns                = data.aws_outposts_outpost.this.arn
      control_plane_instance_type = lookup(outpost_config.value, "control_plane_instance_type")
    }
  }
}

resource "aws_eks_addon" "this" {
  count                       = length(var.cluster) == 0 ? 0 : length(var.addon)
  addon_name                  = lookup(var.addon[count.index], "addon_name")
  cluster_name                = try(
    element(aws_eks_cluster.this.*.name, lookup(var.addon[count.index], "cluster_id"))
  )
  addon_version               = lookup(var.addon[count.index], "addon_version")
  configuration_values        = jsonencode(lookup(var.addon[count.index], "configuration_values"))
  resolve_conflicts_on_create = lookup(var.addon[count.index], "resolve_conflicts_on_create")
  resolve_conflicts_on_update = lookup(var.addon[count.index], "resolve_conflicts_on_update")
  tags                        = merge(
    var.tags,
    lookup(var.addon[count.index], "tags")
  )
  preserve                    = lookup(var.addon[count.index], "preserve")
  service_account_role_arn    = try(
    element(aws_iam_role.this.*.arn, lookup(var.addon[count.index], "role_id"))
  )
}

resource "aws_eks_fargate_profile" "this" {
  count                  = length(var.cluster) == 0 ? 0 : length(var.fargate_profile)
  cluster_name           = try(
    element(aws_eks_cluster.this.*.name, lookup(var.fargate_profile[count.index], "cluster_id"))
  )
  fargate_profile_name   = lookup(var.fargate_profile[count.index], "fargate_profile_name")
  pod_execution_role_arn = try(
    element(aws_iam_role.this.*.arn, lookup(var.fargate_profile[count.index], "role_id"))
  )
  tags                   = merge(
    var.tags,
    lookup(var.fargate_profile[count.index], "tags")
  )
  subnet_ids             = [data.aws_subnet.this.id]

  dynamic "selector" {
    for_each = lookup(var.fargate_profile[count.index], "selector") == null ? [] : ["selector"]
    content {
      namespace = lookup(selector.value, "namespace")
      labels    = merge(
        var.labels,
        lookup(selector.value, "labels")
      )
    }
  }
}

resource "aws_eks_identity_provider_config" "this" {
  count        = length(var.cluster) == 0 ? 0 : length(var.identity_provider_config)
  cluster_name = try(
    element(aws_eks_cluster.this.*.name, lookup(var.identity_provider_config[count.index], "cluster_id"))
  )
  tags         = merge(
    var.tags,
    lookup(var.identity_provider_config[count.index], "tags")
  )

  dynamic "oidc" {
    for_each = lookup(var.identity_provider_config[count.index], "oidc") == null ? [] : ["oidc"]
    content {
      client_id                     = lookup(oidc.value, "client_id")
      identity_provider_config_name = lookup(oidc.value, "identity_provider_config_name")
      issuer_url                    = lookup(oidc.value, "issuer_url")
      groups_claim                  = lookup(oidc.value, "groups_claim")
      groups_prefix                 = lookup(oidc.value, "groups_prefix")
      required_claims               = lookup(oidc.value, "required_claims")
      username_claim                = lookup(oidc.value, "username_claim")
      username_prefix               = lookup(oidc.value, "username_prefix")
    }
  }
}

resource "aws_eks_node_group" "this" {
  count                  = length(var.cluster) == 0 ? 0 : length(var.node_group)
  cluster_name           = try(
    element(aws_eks_cluster.this.*.name, lookup(var.node_group[count.index], "cluster_id"))
  )
  node_group_name        = lookup(var.node_group[count.index], "node_group_name")
  node_role_arn          = try(
    element(aws_iam_role.this.*.arn, lookup(var.node_group[count.index], "role_id"))
  )
  subnet_ids             = [data.aws_subnet.this.id]
  ami_type               = lookup(var.node_group[count.index], "ami_type")
  capacity_type          = lookup(var.node_group[count.index], "capacity_type")
  disk_size              = lookup(var.node_group[count.index], "disk_size")
  force_update_version   = lookup(var.node_group[count.index], "force_update_version")
  instance_types         = lookup(var.node_group[count.index], "instance_types")
  labels                 = merge(
    var.labels,
    lookup(var.node_group[count.index], "labels")
  )
  node_group_name_prefix = lookup(var.node_group[count.index], "node_group_name_prefix")
  release_version        = lookup(var.node_group[count.index], "release_version")
  tags                   = merge(
    var.tags,
    lookup(var.node_group[count.index], "tags") 
  )
  version                = lookup(var.node_group[count.index], "version")

  dynamic "scaling_config" {
    for_each = lookup(var.node_group[count.index], "scaling_config")
    content {
      max_size     = lookup(scaling_config.value, "max_size")
      min_size     = lookup(scaling_config.value, "min_size")
      desired_size = lookup(scaling_config.value, "desired_size")
    }
  }

  dynamic "launch_template" {
    for_each = lookup(var.node_group[count.index], "launch_template") == null ? [] : ["launch_template"]
    content {
      version = lookup(launch_template.value, "version")
      id      = lookup(launch_template.value, "id")
      name    = lookup(launch_template.value, "name")
    }
  }

  dynamic "remote_access" {
    for_each = lookup(var.node_group[count.index], "remote_access") == null ? [] : ["remote_access"]
    content {
      ec2_ssh_key               = lookup(remote_access.value, "ec2_ssh_key")
      source_security_group_ids = [data.aws_security_group.this.id]
    }
  }

  dynamic "taint" {
    for_each = lookup(var.node_group[count.index], "taint") == null ? [] : ["taint"]
    content {
      effect = lookup(taint.value, "effect")
      key    = lookup(taint.value, "key")
      value  = lookup(taint.value, "value")
    }
  }

  dynamic "update_config" {
    for_each = lookup(var.node_group[count.index], "update_config") == null ? [] : ["update_config"]
    content {
      max_unavailable            = lookup(update_config.value, "max_unavailable")
      max_unavailable_percentage = lookup(update_config.value, "max_unavailable_percentage")
    }
  }
}

resource "aws_eks_pod_identity_association" "this" {
  count           = length(var.cluster) == 0 ? 0 : length(var.pod_identity_association)
  role_arn        = try(
    element(aws_iam_role.this.*.arn, lookup(var.pod_identity_association[count.index], "role_id"))
  )
  service_account = lookup(var.pod_identity_association[count.index], "service_account")
  namespace       = lookup(var.pod_identity_association[count.index], "namespace")
  cluster_name    = try(
    element(aws_eks_cluster.this.*.name, lookup(var.pod_identity_association[count.index], "cluster_id"))
  )
  tags            = merge(
    var.tags,
    lookup(var.pod_identity_association[count.index], "tags")
  )
}