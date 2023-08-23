variable "eks_user" {
  description = "which user can connect to eks cluster"
  type        = string
}

variable "cluster_name" {
  description = "Name of EKS cluster"
  type        = string
}

variable "ingress_controller_release_name" {
  description = "ingress-controller helm release name"
  type        = string 
}

variable "ingress_controller_controller_name" {
  description = "Controller name of ingress controller"
  type        = string 
}