resource "helm_release" "nginx_ingress" {
  name       = "ingress-controller"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  values = [
    "${file("resources/ingress-values.yaml")}"
  ]
  depends_on = [ module.eks_cluster ]
}