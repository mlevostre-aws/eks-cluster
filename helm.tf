resource "helm_release" "nginx_ingress" {
  name       = local.ingress_controller_release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = local.ingress_controller_release_name
  depends_on = [module.eks_cluster]
  set {
    name  = "fullnameOverride"
    value = local.ingress_controller_release_name
  }
  set {
    name  = "controller.name "
    value = local.ingress_controller_controller_name
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


resource "helm_release" "datadog" {
  name       = "datadog"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  depends_on = [module.eks_cluster]
  set {
    name  = "datadog.apiKey"
    value = var.datadog_apiKey
  }
}