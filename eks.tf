module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.37.1"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access = true

  create_iam_role = false

  iam_role_arn = "arn:aws:iam::963675898491:role/terraform_role"
  access_entries = {
    # 'my_ec2_admin_entry' est juste un nom logique pour cette configuration
    my_ec2_admin_entry = {
      principal_arn = data.aws_iam_role.ec2_instance_role.arn
      access_policies = {
        # 'cluster-admin' est une politique AWS EKS prédéfinie qui donne des droits complets
        "cluster-admin" = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/eks-cluster-admin-policy"
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

