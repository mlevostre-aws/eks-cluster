resource "helm_release" "nginx_ingress" {
  name       = "ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  values = [
    "${file("resources/ingress-values.yaml")}"
  ]
  depends_on = [module.eks_cluster]
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

resource "helm_release" "gihtub_action" {
  // See documentation https://github.com/actions/actions-runner-controller/blob/master/charts/actions-runner-controller/README.md
  name       = "actions-runner-controller"
  repository = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart      = "actions-runner-controller"
  namespace  = kubernetes_namespace.github.metadata.0.name
  depends_on = [module.eks_cluster, helm_release.cert_manager]
  set {
    name  = "authSecret.create"
    value = "true"
  }

  set {
    name  = "authSecret.github_app_id"
    value = var.github_app_id
  }

  set {
    name  = "authSecret.github_app_installation_id"
    value = var.github_app_installation_id
  }

  set {
    name  = "authSecret.github_app_private_key"
    value = data.aws_secretsmanager_secret_version.secret_github_app_private_key.secret_string
  }
}
