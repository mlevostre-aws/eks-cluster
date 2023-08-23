locals {
  ingress_controller_release_name    = "ingress-nginx"
  ingress_controller_controller_name = "controller"
  ingress_controller_svc_name        = "${local.ingress_controller_release_name}-${local.ingress_controller_controller_name}"
}
