resource "helm_release" "istio-base" {
    
    chart      = "gateway"
    name       = "istio-ingress"
    namespace  = local.namespace
    repository = "https://istio-release.storage.googleapis.com/charts"
    version    = "~> 1.16.1"
    
}