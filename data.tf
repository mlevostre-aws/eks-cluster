data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_role" "ec2_instance_role" {
  name = var.ec2_instance_role_name
}


