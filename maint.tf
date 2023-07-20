provider "aws" {
  region = "eu-west-3"  # Set the Paris region
}

# Create a new VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"  # Adjust the CIDR block as per your requirements
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Create an internet gateway and attach it to the VPC
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Create a public subnet within the VPC
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"  # Adjust the CIDR block as per your requirements
  availability_zone = "eu-west-3a"   # Set your desired AZ in the Paris region
}

# Create a route table for the public subnet and associate it with the internet gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

module "eks_cluster" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name          = "my-eks-cluster"
  subnets               = [aws_subnet.public.id]  # Use the public subnet you created in the VPC
  vpc_id                = aws_vpc.main.id
  # Other module parameters as needed
}

module "node_group" {
  source = "terraform-aws-modules/eks/aws//modules/node_group"

  cluster_name = module.eks_cluster.cluster_id
  node_group_name = "devopstoolchain-workers"
  node_instance_type = "m3.medium"
  node_desired_capacity = 1
  node_min_size = 1
  node_max_size = 2

  # If you want to use a launch template with custom configuration
  # node_launch_template_settings = {
  #   instance_type = "m5.medium"
  #   # Add other settings here
  # }
}


module "fargate_profile" {
  source = "terraform-aws-modules/eks/aws//modules/fargate_profile"
  cluster_name      = module.eks_cluster.cluster_id
  fargate_profile_name = "devopstoolchain-fargate-profile"
  subnet_ids        = [aws_subnet.public.id]  # Use the same public subnet as your EKS nodes
  tags              = {}  # Add any tags if needed
}