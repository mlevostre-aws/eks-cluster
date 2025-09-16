variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "ec2_instance_role_name" {
  description = "The assume role instance of the agent"
  type = string
}