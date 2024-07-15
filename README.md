## Requirements

| Name | Version    |
|------|------------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | \>= 5.58.0 |

## Providers

| Name | Version    |
|------|------------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | \>= 5.58.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_access_entry.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_entry) | resource |
| [aws_eks_access_policy_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_access_policy_association) | resource |
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_fargate_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_fargate_profile) | resource |
| [aws_eks_identity_provider_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_identity_provider_config) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_eks_pod_identity_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_pod_identity_association) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_outposts_outpost.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/outposts_outpost) | data source |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_entry"></a> [access\_entry](#input\_access\_entry) | n/a | <pre>list(object({<br>    id                = number<br>    cluster_id        = number<br>    principal_id      = number<br>    kubernetes_groups = optional(list(string))<br>    tags              = optional(map(string))<br>    type              = optional(string)<br>    user_name         = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_access_policy_association"></a> [access\_policy\_association](#input\_access\_policy\_association) | n/a | <pre>list(object({<br>    id           = number<br>    policy_name  = string<br>    cluster_id   = number<br>    principal_id = number<br>    access_scope = list(object({<br>      type       = string<br>      namespaces = optional(list(string))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_addon"></a> [addon](#input\_addon) | n/a | <pre>list(object({<br>    id                          = number<br>    addon_name                  = string<br>    cluster_id                  = number<br>    addon_version               = optional(string)<br>    configuration_values        = optional(string)<br>    resolve_conflicts_on_create = optional(string)<br>    resolve_conflicts_on_update = optional(string)<br>    tags                        = optional(map(string))<br>    preserve                    = optional(bool)<br>    role_id                     = optional(number)<br>  }))</pre> | `[]` | no |
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | n/a | `string` | `null` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | <pre>list(object({<br>    id                        = number<br>    role_id                   = optional(number)<br>    name                      = string<br>    enabled_cluster_log_types = optional(list(string))<br>    tags                      = optional(map(string))<br>    version                   = optional(string)<br>    vpc_config = list(object({<br>      subnet_ids              = list(string)<br>      security_group_ids      = list(string)<br>      public_access_cidrs     = optional(list(string))<br>      endpoint_private_access = optional(bool)<br>      endpoint_public_access  = optional(bool)<br>    }))<br>    access_config = optional(list(object({<br>      authentication_mode                         = optional(string)<br>      bootstrap_cluster_creator_admin_permissions = optional(bool)<br>    })), [])<br>    encryption_config = optional(list(object({<br>      resources = list(string)<br>      provider = list(object({<br>        key_id = optional(number)<br>      }))<br>    })), [])<br>    kubernetes_network_config = optional(list(object({<br>      service_ipv4_cidr = optional(string)<br>      ip_family         = optional(string)<br>    })), [])<br>    outpost_config = optional(list(object({<br>      control_plane_instance_type = string<br>      outpost_ids                 = optional(list(number))<br>      control_plane_placement = optional(list(object({<br>        group_name = string<br>      })), [])<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_fargate_profile"></a> [fargate\_profile](#input\_fargate\_profile) | n/a | <pre>list(object({<br>    id                   = number<br>    cluster_id           = number<br>    fargate_profile_name = string<br>    role_id              = number<br>    tags                 = optional(map(string))<br>    subnet_ids           = list(string)<br>    selector = list(object({<br>      namespace = string<br>      labels    = optional(map(string))<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_identity_provider_config"></a> [identity\_provider\_config](#input\_identity\_provider\_config) | n/a | <pre>list(object({<br>    id         = number<br>    cluster_id = number<br>    tags       = optional(map(string))<br>    oidc = list(object({<br>      client_id                     = string<br>      identity_provider_config_name = string<br>      issuer_url                    = string<br>      groups_claim                  = optional(string)<br>      groups_prefix                 = optional(string)<br>      required_claims               = optional(map(string))<br>      username_claim                = optional(string)<br>      username_prefix               = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | n/a | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | n/a | `map(string)` | `{}` | no |
| <a name="input_node_group"></a> [node\_group](#input\_node\_group) | n/a | <pre>list(object({<br>    id                     = number<br>    cluster_id             = number<br>    node_group_name        = string<br>    node_role_id           = number<br>    subnet_ids             = list(number)<br>    ami_type               = optional(string)<br>    capacity_type          = optional(string)<br>    disk_size              = optional(number)<br>    force_update_version   = optional(bool)<br>    instance_types         = optional(list(string))<br>    labels                 = optional(map(string))<br>    node_group_name_prefix = optional(string)<br>    release_version        = optional(string)<br>    tags                   = optional(map(string))<br>    version                = optional(string)<br>    scaling_config = list(object({<br>      max_size     = number<br>      min_size     = number<br>      desired_size = number<br>    }))<br>    launch_template = optional(list(object({<br>      version = string<br>      id      = optional(string)<br>      name    = optional(string)<br>    })), [])<br>    remote_access = optional(list(object({<br>      ec2_ssh_key               = optional(string)<br>      source_security_group_ids = optional(list(string))<br>    })), [])<br>    taint = optional(list(object({<br>      effect = string<br>      key    = string<br>      value  = optional(string)<br>    })), [])<br>    update_config = optional(list(object({<br>      max_unavailable            = optional(number)<br>      max_unavailable_percentage = optional(number)<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_outpost_name"></a> [outpost\_name](#input\_outpost\_name) | n/a | `string` | `null` | no |
| <a name="input_pod_identity_association"></a> [pod\_identity\_association](#input\_pod\_identity\_association) | n/a | <pre>list(object({<br>    id              = number<br>    role_id         = number<br>    service_account = string<br>    namespace       = string<br>    cluster_id      = number<br>    tags            = optional(map(string))<br>  }))</pre> | `[]` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | n/a | <pre>list(object({<br>    id   = number<br>    name = string<br>  }))</pre> | `[]` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | n/a | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | n/a | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eks_addon_arn"></a> [eks\_addon\_arn](#output\_eks\_addon\_arn) | n/a |
| <a name="output_eks_addon_id"></a> [eks\_addon\_id](#output\_eks\_addon\_id) | n/a |
| <a name="output_eks_cluster_arn"></a> [eks\_cluster\_arn](#output\_eks\_cluster\_arn) | n/a |
| <a name="output_eks_cluster_id"></a> [eks\_cluster\_id](#output\_eks\_cluster\_id) | n/a |
| <a name="output_eks_cluster_oidc_issuer"></a> [eks\_cluster\_oidc\_issuer](#output\_eks\_cluster\_oidc\_issuer) | n/a |
| <a name="output_eks_node_group_arn"></a> [eks\_node\_group\_arn](#output\_eks\_node\_group\_arn) | n/a |
| <a name="output_node_group_id"></a> [node\_group\_id](#output\_node\_group\_id) | n/a |
