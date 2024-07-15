run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "aws_eks_on_outpost" {
  command = [init,plan,apply]

  variables {
    outpost_name = "outpost_4_eks"
    cluster = [
      {
        id    = 0
        name  = "eks-cluster-1"
        vpc_config = [
          {
            endpoint_private_access = true
            endpoint_public_access  = false
          }
        ]
        outpost_config = [
          {
            control_plane_instance_type = "m5d.large"
          }
        ]
      }
    ]
  }
}

run "aws_eks_basic_with_addon_and_node_group" {
  command = [init,plan,apply]

  variables {
    subnet_id = "subnet-1"
    cluster = [
      {
        id    = 0
        name  = "eks-cluster-1"
        vpc_config = [
          {
            endpoint_private_access = true
            endpoint_public_access  = false
          }
        ]
      }
    ]
    addon = [
      {
        id                          = 0
        cluster_id                  = 0
        addon_name                  = "coredns"
        addon_version               = "v1.10.1-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
        resolve_conflicts_on_update = "PRESERVE"
      }
    ]
    node_group = [
      {
        id              = 0
        cluster_id      = 0
        node_group_name = "example"
        scaling_config = [
          {
            desired_size = 1
            max_size     = 2
            min_size     = 1
          }
        ]
        update_config = [
          {
            max_unavailable = 1
          }
        ]
      }
    ]
  }
}