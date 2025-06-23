module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37.1"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access = true

  create_iam_role = false
  enable_cluster_creator_admin_permissions = true
  
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

