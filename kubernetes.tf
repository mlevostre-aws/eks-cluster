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
    api_groups = [""]
    resources = [
      "namespaces",
      "configmaps",
      "events",
      "replicationcontrollers",
      "serviceaccounts",
      "pods/log",
    ]
    verbs = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "secrets"]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }

  rule {
    api_groups = ["autoscaling"]
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["list", "get"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["controllerrevisions"]
    verbs      = ["list"]
  }

  rule {
    api_groups = ["extensions", "apps"]
    resources  = ["daemonsets", "deployments", "deployments/scale", "ingresses", "replicasets", "statefulsets"]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
  }

  rule {
    api_groups = [""]
    resources  = ["services/proxy", "pods/portforward"]
    verbs = [
      "create",
      "delete",
      "deletecollection",
      "get",
      "list",
      "patch",
      "update",
      "watch",
    ]
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
