data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "kubernetes_service" "ingress_controller_svc" {
  metadata {
    name = local.ingress_controller_svc_name
  }
  depends_on = [ helm_release.nginx_ingress ]
}
data "aws_route53_zone" "domain" {
  name         = "${var.domain}."
}