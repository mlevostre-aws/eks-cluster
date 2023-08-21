data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_secretsmanager_secret" "secret_github_app_private_key" {
  name = var.secret_github_app_private_key
}

data "aws_secretsmanager_secret_version" "secret_github_app_private_key" {
  secret_id = data.aws_secretsmanager_secret.secret_github_app_private_key.id
}
