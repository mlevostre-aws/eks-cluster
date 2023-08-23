variable "eks_user" {
  description = "which user can connect to eks cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variables "domain" {
  description = "DNS domain"
  type        = string
}