module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "devops-toolchain-cluster"
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access = true

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

  # Fargate Profile(s)
  fargate_profiles = {
    application = {
      name = "application"
      selectors = [
        {
          namespace = "application"
        }
      ]
    }
    github = {
      name = "github"
      selectors = [
        {
          namespace = local.github_action_namespace
        }
      ]
    }
  }

  
  # aws-auth configmap
  manage_aws_auth_configmap = true
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.eks_user}"
      username = "${var.eks_user}"
      groups   = ["system:masters"]
    }
  ]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

