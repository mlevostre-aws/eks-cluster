variable "aws_account_id" {
  description = "AWS account id"
  type        = string
  sensitive   = true
}
variable "eks_user" {
  description = "which user can connect to eks cluster"
  type        = string
}
