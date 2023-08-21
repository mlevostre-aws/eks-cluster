
resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = "spinnaker"
  }
  depends_on = [module.eks_cluster]
}

resource "kubernetes_namespace" "application" {
  metadata {
    name = "application"
  }
  depends_on = [module.eks_cluster]
}

resource "kubernetes_service_account" "spinnaker_service_account" {
  metadata {
    namespace = kubernetes_namespace.spinnaker.metadata.0.name
    name      = "spinnaker-service-account"
  }
}

resource "kubernetes_secret" "spinnaker_service_account_secret" {
  metadata {
    namespace = kubernetes_namespace.spinnaker.metadata.0.name
    name      = "spinnaker-service-account-secret"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.spinnaker_service_account.metadata.0.name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role" "spinnaker_cluster_role" {
  metadata {
    name = "spinnaker-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    non_resource_urls = ["*"]
    verbs             = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "spinnaker_cluster_role" {
  metadata {
    name = "spinnaker-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.spinnaker_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.spinnaker_service_account.metadata.0.name
    namespace = kubernetes_namespace.spinnaker.metadata.0.name
  }
}
