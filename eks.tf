module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37.1"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access = true


  create_iam_role = false
  enable_cluster_creator_admin_permissions = true
  iam_role_arn = "arn:aws:iam::963675898491:role/terraform_role"
  authentication_mode = "API_AND_CONFIG_MAP"
  access_entries = {
    # One access entry with a policy associated
    admin = {
      principal_arn = "arn:aws:iam::963675898491:user/local"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }
  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 5
      desired_size = 3

      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
      labels = {
        node = "default"
      }

    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

