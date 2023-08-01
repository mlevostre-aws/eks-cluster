resource "kubernetes_namespace_v1" "devops" {
  metadata {
    name = "devops"
  }
}
