variable "eks_user" {
  description = "which user can connect to eks cluster"
  type        = string
}

variable "secret_github_app_private_key" {
  description = "Name of AWSSecret where is the Github APP private key for Github Action application"
  type        = string
}

variable "github_app_id" {
  description = "Github app ID for Github Action application"
  type        = string
}

variable "github_app_installation_id" {
  description = "Github app instalation ID for Github Action application"
  type        = string
}