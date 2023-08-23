resource "helm_release" "nginx_ingress" {
  name       = var.ingress_controller_release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = var.ingress_controller_release_name
  depends_on = [module.eks_cluster]
  set {
    name  = "fullnameOverride"
    value = var.ingress_controller_release_name
  }
  set {
    name  = "controller.name "
    value = var.ingress_controller_controller_name
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.12.3"
  depends_on = [module.eks_cluster]
  set {
    name  = "installCRDs"
    value = "true"
  }
}
