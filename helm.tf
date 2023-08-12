resource "helm_release" "nginx_ingress" {
  name       = "ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = local.ingress_controler_version
  values = [
    "${file("resources/ingress-values.yaml")}"
  ]
  depends_on = [ module.eks_cluster ]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = local.cert_manager_version
  depends_on = [ module.eks_cluster ]
  set {
    name  = "installCRDs"
    value = "true"
  }
}