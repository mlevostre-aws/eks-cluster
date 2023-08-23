resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.domain.zone_id
  name    = "*.${data.aws_route53_zone.domain.name}"
  type    = "A"
  ttl     = "300"
  records = [
    data.kubernetes_service.ingress_controller_svc.status.0.load_balancer.0.ingress.0.hostname
  ]
}