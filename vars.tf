variable "tags" {
  type    = map(string)
  default = {}
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "security_group_id" {
  type    = string
  default = null
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "outpost_name" {
  type    = string
  default = null
}

variable "eks_access_entry_principal_arn" {
  type    = string
  default = null
}

variable "eks_access_policy_association_principal_arn" {
  type    = string
  default = null
}

variable "eks_cluster_role_arn" {
  type    = string
  default = null
}

variable "eks_addon_service_account_role_arn" {
  type    = string
  default = null
}

variable "eks_fargate_profile_pod_execution_role_arn" {
  type    = string
  default = null
}

variable "eks_node_group_role_arn" {
  type    = string
  default = null
}

variable "eks_pod_identity_association_role_arn" {
  type    = string
  default = null
}

variable "access_entry" {
  type = list(object({
    id                = number
    cluster_id        = number
    kubernetes_groups = optional(list(string))
    tags              = optional(map(string))
    type              = optional(string)
    user_name         = optional(string)
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "access_policy_association" {
  type = list(object({
    id           = number
    policy_name  = string
    cluster_id   = number
    access_scope = list(object({
      type       = string
      namespaces = optional(list(string))
    }))
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "cluster" {
  type = list(object({
    id                        = number
    name                      = string
    enabled_cluster_log_types = optional(list(string))
    tags                      = optional(map(string))
    version                   = optional(string)
    vpc_config = list(object({
      subnet_ids              = list(string)
      security_group_ids      = list(string)
      public_access_cidrs     = optional(list(string))
      endpoint_private_access = optional(bool)
      endpoint_public_access  = optional(bool)
    }))
    access_config = optional(list(object({
      authentication_mode                         = optional(string)
      bootstrap_cluster_creator_admin_permissions = optional(bool)
    })), [])
    encryption_config = optional(list(object({
      resources = list(string)
      provider = list(object({
        key_id = optional(number)
      }))
    })), [])
    kubernetes_network_config = optional(list(object({
      service_ipv4_cidr = optional(string)
      ip_family         = optional(string)
    })), [])
    outpost_config = optional(list(object({
      control_plane_instance_type = string
      outpost_ids                 = optional(list(number))
      control_plane_placement = optional(list(object({
        group_name = string
      })), [])
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "addon" {
  type = list(object({
    id                          = number
    addon_name                  = string
    cluster_id                  = number
    addon_version               = optional(string)
    configuration_values        = optional(string)
    resolve_conflicts_on_create = optional(string)
    resolve_conflicts_on_update = optional(string)
    tags                        = optional(map(string))
    preserve                    = optional(bool)
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "fargate_profile" {
  type = list(object({
    id                   = number
    cluster_id           = number
    fargate_profile_name = string
    tags                 = optional(map(string))
    subnet_ids           = list(string)
    selector = list(object({
      namespace = string
      labels    = optional(map(string))
    }))
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "identity_provider_config" {
  type = list(object({
    id         = number
    cluster_id = number
    tags       = optional(map(string))
    oidc = list(object({
      client_id                     = string
      identity_provider_config_name = string
      issuer_url                    = string
      groups_claim                  = optional(string)
      groups_prefix                 = optional(string)
      required_claims               = optional(map(string))
      username_claim                = optional(string)
      username_prefix               = optional(string)
    }))
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "node_group" {
  type = list(object({
    id                     = number
    cluster_id             = number
    node_group_name        = string
    subnet_ids             = list(number)
    ami_type               = optional(string)
    capacity_type          = optional(string)
    disk_size              = optional(number)
    force_update_version   = optional(bool)
    instance_types         = optional(list(string))
    labels                 = optional(map(string))
    node_group_name_prefix = optional(string)
    release_version        = optional(string)
    tags                   = optional(map(string))
    version                = optional(string)
    scaling_config = list(object({
      max_size     = number
      min_size     = number
      desired_size = number
    }))
    launch_template = optional(list(object({
      version = string
      id      = optional(string)
      name    = optional(string)
    })), [])
    remote_access = optional(list(object({
      ec2_ssh_key               = optional(string)
      source_security_group_ids = optional(list(string))
    })), [])
    taint = optional(list(object({
      effect = string
      key    = string
      value  = optional(string)
    })), [])
    update_config = optional(list(object({
      max_unavailable            = optional(number)
      max_unavailable_percentage = optional(number)
    })), [])
  }))
  default     = []
  description = <<EOF
    EOF
}

variable "pod_identity_association" {
  type = list(object({
    id              = number
    service_account = string
    namespace       = string
    cluster_id      = number
    tags            = optional(map(string))
  }))
  default     = []
  description = <<EOF
    EOF
}