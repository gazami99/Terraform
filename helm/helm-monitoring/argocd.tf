resource "helm_release" "argocd" {

    chart      = "argo-cd"
    name       = "argocd"
    namespace  = local.namespace
    repository = "https://argoproj.github.io/argo-helm"
    version    = "~> 5.16.0"
}