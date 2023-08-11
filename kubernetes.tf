resource "kubernetes_namespace" "devops" {
  metadata {
    name = "devops"
  }
}

resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = "spinnaker"
  }
}

resource "kubernetes_service_account" "spinnaker_service_account" {
  metadata {
    namespace = kubernetes_namespace.spinnaker.metadata[0].name
    name = "spinnaker-service-account"
  }
}

resource "kubernetes_secret" "spinnaker_service_account_secret" {
  metadata {
    namespace = kubernetes_namespace.spinnaker.metadata[0].name
    name      = "spinnaker-service-account-secret"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.spinnaker_service_account.metadata[0].name
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
    verbs = ["*"]
    non_resource_urls = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "spinnaker_cluster_role" {
  metadata {
    name = "spinnaker-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.spinnaker_cluster_role.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.spinnaker_service_account.metadata[0].name
    namespace = kubernetes_namespace.spinnaker.metadata[0].name
  }
}


hal config provider kubernetes account add devops-toolchain-cluster --context $CONTEXT

hal config version edit --version 1.31.0

hal config deploy edit --type distributed --account-name devops-toolchain-cluster

hal config storage s3 edit --region eu-west-3