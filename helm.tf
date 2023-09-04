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

  values = [
    "${file("resources/ingress-values.yaml")}"
  ]
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

resource "helm_release" "datadog_crds" {
  name       = "datadog-crds"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog-crds"
  version    = "1.0.1"
  depends_on = [module.eks_cluster]
}

resource "helm_release" "kube_state_metrics" {
  name       = "kube-state-metrics"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-state-metrics"
  version    = "2.13.2"
  depends_on = [module.eks_cluster]
}

resource "helm_release" "datadog" {
  name       = "datadog"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  depends_on = [helm_release.datadog_crds, helm_release.kube_state_metrics]
  set {
    name  = "datadog.apiKey"
    value = var.datadog_apiKey
  }
  set {
    name  = "datadog.site"
    value = "datadoghq.eu"
  }
  set {
    name  = "datadog.logs.enabled"
    value = "true"
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = "true"
  }
}

